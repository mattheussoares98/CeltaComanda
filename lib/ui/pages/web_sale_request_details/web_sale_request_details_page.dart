import 'dart:async';

import 'package:collection/collection.dart';
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

  Map<int?, List<ConcSaleRequestModel>> getRequestsGroupedByLot(
    List<ConcSaleRequestModel> originalRequests,
    IsToDelivery status,
  ) {
    // 1. Create a flattened list of "Single-Product Requests"
    // This handles the case where one Request has products in different Lots.
    final List<ConcSaleRequestModel> flattenedRequests = [];

    for (var request in originalRequests) {
      // Filter products by status
      final filteredProducts =
          request.Products.where((p) => p.isToDelivery == status).toList();

      if (filteredProducts.isEmpty) continue;

      // Group these filtered products by their DeliveryLot
      final productsByLot = groupBy(filteredProducts, (p) => p.DeliveryLot);

      // Create a unique Request entity for each Lot found within the same SaleRequest
      productsByLot.forEach((lotId, products) {
        flattenedRequests.add(request.copyWith(Products: products));
      });
    }

    // 2. Group the resulting requests by the DeliveryLot (looking at the first product)
    return groupBy(flattenedRequests, (req) => req.Products.first.DeliveryLot);
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

          return Row(
            children: [
              Expanded(
                child: RequestsItems(
                  isToDeliveryStatus: IsToDelivery.preparing,
                  saleRequests: List.of(snapshot.data!.values),
                ),
              ),
              Expanded(
                child: RequestsItems(
                  isToDeliveryStatus: IsToDelivery.ready,
                  saleRequests: List.of(snapshot.data!.values),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
