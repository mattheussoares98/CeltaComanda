// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/models.dart';
import '../../../../domain/entities/entities.dart';
import '../../../helpers/helpers.dart';
import '../web_sale_request_details.dart';
import 'components.dart';

class RequestsItems extends StatelessWidget {
  final List<ConcSaleRequestModel> saleRequests;
  final IsToDelivery isToDeliveryStatus;

  const RequestsItems({
    super.key,
    required this.saleRequests,
    required this.isToDeliveryStatus,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isToDeliveryStatus == IsToDelivery.preparing
        ? Colors.amber
        : Colors.green;

    List<ConcSaleRequestModel> splitRequestsByLotAndStatus(
        List<ConcSaleRequestModel> originalRequests, IsToDelivery status) {
      final List<ConcSaleRequestModel> explodedList = [];

      for (var request in originalRequests) {
        // 1. Filter products by the requested status first
        final validProducts =
            request.Products.where((p) => p.isToDelivery == status).toList();

        if (validProducts.isEmpty) continue;

        // 2. Group the valid products by their DeliveryLot
        // This identifies how many unique lots exist in THIS specific request
        final productsByLot = groupBy(validProducts, (p) => p.DeliveryLot);

        // 3. For each unique lot, create a new 'exploded' version of the SaleRequest
        for (var entry in productsByLot.entries) {
          final productsForThisSpecificLot = entry.value;

          explodedList.add(
            request.copyWith(
              Products: productsForThisSpecificLot,
            ),
          );
        }
      }

      return explodedList;
    }

    final filteredSaleRequests =
        splitRequestsByLotAndStatus(saleRequests, isToDeliveryStatus);
    filteredSaleRequests.sort((a, b) {
      final dateA = a.Products.first.DateHourOfCreation;
      final dateB = b.Products.first.DateHourOfCreation;

      if (dateA == null && dateB == null) return 0;
      if (dateA == null) return 1;
      if (dateB == null) return -1;

      return dateA.compareTo(dateB);
    });

    return Container(
      color: color.withAlpha(20),
      child: Column(
        children: [
          Text(
            isToDeliveryStatus == IsToDelivery.preparing
                ? R.string.preparing
                : R.string.ready,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineLarge
                ?.copyWith(color: color, fontWeight: FontWeight.bold, shadows: [
              const Shadow(
                color: Colors.black12,
                offset: Offset(1, 1),
              ),
            ]),
          ),
          Expanded(
            child: ResponsiveListFlow(
              itemCount: filteredSaleRequests.length,
              itemBuilder: (_, index) {
                final item = filteredSaleRequests.elementAt(index);
                // final deliveryLotId = item.key;
                final saleRequest = item;

                final products = saleRequest.Products;

                // return const Text('working');

                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onDoubleTap: () {
                      Provider.of<WebSaleRequestDetailsPresenter>(context,
                              listen: false)
                          .updateDeliveryControlStatus(
                        saleRequestId: saleRequest.SaleRequestId,
                        deliveryLotId: saleRequest.Products.first.DeliveryLot!,
                        newStatus: isToDeliveryStatus == IsToDelivery.preparing
                            ? IsToDelivery.ready
                            : IsToDelivery.delivered,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          CommandTableAndLastChangedTime(
                            saleRequest: saleRequest,
                            mostRecentRequestFromCurrentSale:
                                saleRequest.Products.first.DateHourOfCreation!,
                          ),
                          const Divider(thickness: 0.1),
                          // if (products.isEmpty)
                          //   //!quando marca como pronto, salva o horário do campo DateHourOfDelivery. Mas quando marca como preparando de novo, esse campo
                          //   //!continua igual. Esse campo é usado para identificar os produtos que foram solicitados após a última entrega
                          //   Row(
                          //     children: [
                          //       Expanded(
                          //           child: Text(
                          //         R.string.msgAllProductsAreDelivered,
                          //         style: const TextStyle(color: Colors.red),
                          //       )),
                          //       const Icon(
                          //         Icons.error,
                          //         color: Colors.red,
                          //       ),
                          //     ],
                          //   ),
                          ProductsItems(
                            products: products,
                            isPreparingColumn:
                                isToDeliveryStatus == IsToDelivery.preparing,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
