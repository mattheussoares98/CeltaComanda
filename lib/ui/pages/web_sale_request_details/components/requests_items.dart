// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/models.dart';
import '../../../../domain/entities/entities.dart';
import '../../../helpers/helpers.dart';
import '../web_sale_request_details.dart';
import 'components.dart';

class RequestsItems extends StatelessWidget {
  final DateTime? Function(List<ConcSaleRequestModel> sales)
      findMostRecentDateFromSales;
  final List<ConcSaleRequestModel> requests;
  final bool isPreparingColumn;

  const RequestsItems({
    super.key,
    required this.findMostRecentDateFromSales,
    required this.requests,
    required this.isPreparingColumn,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isPreparingColumn ? Colors.amber : Colors.green;

    return Container(
      color: color.withAlpha(20),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Text(
              isPreparingColumn ? R.string.preparing : R.string.ready,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    const Shadow(
                      color: Colors.black12,
                      offset: Offset(1, 1),
                    ),
                  ]),
            ),
          ),
          ResponsiveListFlow(
            isSliver: true,
            itemCount: requests.length,
            itemBuilder: (_, index) {
              final saleRequest = requests[index];

              final products = saleRequest.Products.where((e) {
                if (saleRequest.DateHourOfDelivery == null ||
                    !isPreparingColumn) {
                  return e.SaleRequestProductIdOfFather == null;
                }

                return e.SaleRequestProductIdOfFather == null &&
                    e.DateHourOfCreation!.isAfter(
                      saleRequest.DateHourOfDelivery!,
                    );
              }).toList();

              // return const Text('working');

              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onDoubleTap: () {
                    Provider.of<WebSaleRequestDetailsPresenter>(context,
                            listen: false)
                        .updateDeliveryControlStatus(
                      deliveryControlId: saleRequest.SaleRequestId,
                      newStatus: isPreparingColumn
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
                              findMostRecentDateFromSales([saleRequest])!,
                        ),
                        const Divider(thickness: 0.1),
                        if (products.isEmpty)
                          //!quando marca como pronto, salva o horário do campo DateHourOfDelivery. Mas quando marca como preparando de novo, esse campo
                          //!continua igual. Esse campo é usado para identificar os produtos que foram solicitados após a última entrega
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                R.string.msgAllProductsAreDelivered,
                                style: const TextStyle(color: Colors.red),
                              )),
                              const Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ProductsItems(
                          products: products,
                          isPreparingColumn: isPreparingColumn,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
