import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/conc_sale_request/conc_sale_request.dart';
import '../../../domain/entities/entities.dart';
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
    provider.loadOpenSaleRequests();
  }

  DateTime? findMostRecentDateFromSales(List<ConcSaleRequestModel> sales) {
    final allDateStrings = sales.expand((sale) {
      final List<String?> dates = [sale.DateHourOfCreation.toIso8601String()];

      // dates.addAll(sale.Products.map((p) => p.));

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

    return Scaffold(
      body: StreamBuilder(
        stream: provider.saleRequestsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData == false || snapshot.data!.isEmpty) {
            return Center(
              child: Text(R.string.emptySaleRequests),
            );
          }

          final List<ConcSaleRequestModel> saleRequests =
              List.of(snapshot.data!.values);
          saleRequests.sort((a, b) {
            final dateA = findMostRecentDateFromSales([a]);
            final dateB = findMostRecentDateFromSales([b]);

            if (dateA == null && dateB == null) return 0;
            if (dateA == null) return 1;
            if (dateB == null) return -1;

            return dateB.compareTo(dateA);
          });

          final preparing = saleRequests
              .where(
                  (e) => e.isToDelivery?.value == IsToDelivery.preparing.value)
              .toList();
          final ready = saleRequests
              .where((e) => e.isToDelivery?.value == IsToDelivery.ready.value)
              .toList();

          return Row(
            children: [
              Expanded(
                child: RequestsItems(
                  findMostRecentDateFromSales: findMostRecentDateFromSales,
                  requests: preparing,
                  isPreparingColumn: true,
                ),
              ),
              Expanded(
                child: RequestsItems(
                  findMostRecentDateFromSales: findMostRecentDateFromSales,
                  requests: ready,
                  isPreparingColumn: false,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
