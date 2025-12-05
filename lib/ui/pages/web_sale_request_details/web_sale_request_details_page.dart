import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../data/models/models.dart';
import '../../../main/builders/builders.dart';
import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';
import 'components/components.dart';

class WebSaleRequestDetailsPage extends StatefulWidget {
  const WebSaleRequestDetailsPage({super.key});

  @override
  State<WebSaleRequestDetailsPage> createState() =>
      _WebSaleRequestDetailsPageState();
}

class _WebSaleRequestDetailsPageState extends State<WebSaleRequestDetailsPage>
    with UIErrorManager {
  Timer? _dataRefreshTimer;
  StreamSubscription? mainErrorSubscription;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        _dataRefreshTimer = Timer.periodic(
          const Duration(seconds: 30),
          (timer) {
            _fetchAndUpdateData();
          },
        );

        _fetchAndUpdateData();
      }
    });
  }

  @override
  void dispose() {
    _dataRefreshTimer?.cancel();
    mainErrorSubscription?.cancel();
    super.dispose();
  }

  void _fetchAndUpdateData() {
    final provider =
        Provider.of<WebSaleRequestDetailsPresenter>(context, listen: false);
    provider.loadOpenSaleRequests(isConsiderDelivered: true);
  }

  DateTime? findMostRecentDateFromSales(List<SaleRequestModel> sales) {
    final allDateStrings = sales.expand((sale) {
      final List<String?> dates = [sale.DateHourOfCreation];

      if (sale.Products != null) {
        dates.addAll(sale.Products!.map((p) => p.DateHourOfCreation));
      }

      return dates;
    });

    final allDates = allDateStrings
        .whereType<String>()
        .map((dateString) => DateTime.tryParse(dateString))
        .whereType<DateTime>()
        .toList();

    if (allDates.isEmpty) {
      return null;
    }

    return allDates.reduce((a, b) => a.isAfter(b) ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<WebSaleRequestDetailsPresenter>(context, listen: false);
    final homePresenter = Provider.of<HomePresenter>(context, listen: false);
    mainErrorSubscription = handleMainError(context, provider.mainErrorStream);
    final theme = Theme.of(context);

    return ListenFirebaseStreamAndCallFunction(
      collection: "clients",
      doc: EnterpriseBuilder.entity!.enterpriseName,
      function: (data) async {
        await homePresenter.doOnRemoteEnterpriseChanges(
          data: data,
          menuPresenter: Provider.of<MenuPresenter>(context, listen: false),
          printedProductsPresenter:
              Provider.of<PrintedProductsPresenter>(context, listen: false),
          cartPresenter: Provider.of<CartPresenter>(context, listen: false),
          expansibleGroupFromProductPresenter:
              Provider.of<ExpansibleGroupFromProductPresenter>(context,
                  listen: false),
          enterprisePresenter:
              Provider.of<EnterprisePresenter>(context, listen: false),
        );
      },
      child: Scaffold(
        body: StreamBuilder(
          stream: provider.saleRequestsStream,
          builder: (context, snapshot) {
            if (snapshot.hasData == false || snapshot.data!.isEmpty) {
              return Center(
                child: Text(R.string.emptySaleRequests),
              );
            }

            final List<SaleRequestModel> saleRequests = List.of(snapshot.data!);
            saleRequests.sort((a, b) {
              final dateA = findMostRecentDateFromSales([a]);
              final dateB = findMostRecentDateFromSales([b]);

              if (dateA == null && dateB == null) return 0;
              if (dateA == null) return 1;
              if (dateB == null) return -1;

              return dateB.compareTo(dateA);
            });

            return ResponsiveListFlow(
              itemCount: saleRequests.length,
              itemBuilder: (_, index) {
                final saleRequest = saleRequests[index];

                final mostRecentRequestFromCurrentSale =
                    findMostRecentDateFromSales([saleRequest]);

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: RichText(
                                text: TextSpan(
                                  style: theme.textTheme.titleMedium,
                                  children: [
                                    TextSpan(
                                      text:
                                          "${R.string.command} ${saleRequest.PersonalizedCode!}",
                                      style: theme.textTheme.titleLarge,
                                    ),
                                    if (saleRequest.PlaceId != null &&
                                        saleRequest.PlaceId!.isNotEmpty)
                                      TextSpan(
                                        text:
                                            ' - Mesa (${saleRequest.PlaceId!})',
                                        style: theme.textTheme.titleLarge,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                DateFormat("dd/MM HH:mm:ss")
                                    .format(mostRecentRequestFromCurrentSale!),
                                textAlign: TextAlign.end,
                              ),
                            )
                          ],
                        ),
                        const Divider(
                          thickness: 0.1,
                        ),
                        ResponsiveListFlow(
                            shrinkWrap: true,
                            itemCount: saleRequest.Products!.length,
                            itemBuilder: (_, index) {
                              final product = saleRequest.Products![index];

                              return Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: RichText(
                                      text: TextSpan(
                                        style: theme.textTheme.titleSmall,
                                        children: [
                                          TextSpan(
                                            text: product.Quantity.toString()
                                                .toBrazilianNumber(2, true),
                                          ),
                                          const TextSpan(
                                            text: ' x ',
                                          ),
                                          TextSpan(text: product.product!.Name),
                                          if (product.Comments != null)
                                            TextSpan(
                                              text: ' (${product.Comments!})',
                                              style: theme.textTheme.titleMedium
                                                  ?.copyWith(
                                                      color: Colors.red,
                                                      fontStyle:
                                                          FontStyle.italic),
                                            )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      DateFormat("dd/MM HH:mm:ss").format(
                                        DateTime.parse(
                                            product.DateHourOfCreation!),
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
