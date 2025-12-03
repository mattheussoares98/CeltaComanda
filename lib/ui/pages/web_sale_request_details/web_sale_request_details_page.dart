import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../data/models/models.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';

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
    mainErrorSubscription = handleMainError(context, provider.mainErrorStream);
    final theme = Theme.of(context);

    return Scaffold(
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

          return ListView.builder(
            itemCount: saleRequests.length,
            itemBuilder: (_, index) {
              final saleRequest = saleRequests[index];

              final mostRecentRequestFromCurrentSale =
                  findMostRecentDateFromSales([saleRequest]);

              return Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: theme.primaryColorLight.withAlpha(40),
                  collapsedBackgroundColor:
                      theme.primaryColorLight.withAlpha(20),
                  childrenPadding: EdgeInsets.only(
                    bottom: index + 1 == snapshot.data!.length ? 8 : 0,
                  ),
                  iconColor: theme.primaryColorDark,
                  collapsedIconColor: theme.primaryColor,
                  title: Text(
                    "${R.string.command} ${saleRequest.PersonalizedCode!}",
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.primaryColorDark,
                    ),
                  ),
                  subtitle: Text(
                    ' ${R.string.lastRequest} ${DateFormat('dd/MM HH:mm').format(mostRecentRequestFromCurrentSale!)}',
                    style: theme.textTheme.titleMedium,
                  ),
                  children: [const Text('subproducts?')],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
