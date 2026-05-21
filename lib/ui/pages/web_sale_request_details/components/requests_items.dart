import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/entities/entities.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';
import 'components.dart';

class RequestsItems extends StatelessWidget {
  final List<DeliveryControlEntity> deliveryControls;
  final IsToDelivery isToDeliveryStatus;

  const RequestsItems({
    super.key,
    required this.deliveryControls,
    required this.isToDeliveryStatus,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isToDeliveryStatus == IsToDelivery.preparing
        ? Colors.amber
        : Colors.green;

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
              itemCount: deliveryControls
                  .where((e) => e.isToDelivery == isToDeliveryStatus)
                  .length,
              itemBuilder: (_, index) {
                final deliveryControl = deliveryControls
                    .where((e) => e.isToDelivery == isToDeliveryStatus)
                    .elementAt(index);
                final products = deliveryControl.Products!;
                return Card(
                  clipBehavior: Clip.antiAlias,
                  color:
                      deliveryControl.Products!.first.deliveryStatusLate.color,
                  child: InkWell(
                    onDoubleTap: () {
                      Provider.of<WebSaleRequestDetailsPresenter>(context,
                              listen: false)
                          .updateDeliveryControlStatus(
                        deliveryControl: deliveryControl,
                        deliveryLotId:
                            deliveryControl.Products?.first.DeliveryLoteNumber,
                        newStatus: isToDeliveryStatus == IsToDelivery.preparing
                            ? IsToDelivery.ready
                            : IsToDelivery.delivered,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommandTableAndLastChangedTime(
                            deliveryControl: deliveryControl,
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                final product = products.elementAt(index);
                                final children = product.children;

                                return Column(
                                  children: [
                                    ProductInfo(
                                      deliveryControl: deliveryControl,
                                      product: product,
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: children?.length,
                                      itemBuilder: (context, index) {
                                        return ProductInfo(
                                          deliveryControl: deliveryControl,
                                          product: children!.elementAt(index),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              }),
                        ],
                      ),
                    ),
                  ),
                );

                // return Card(
                //   clipBehavior: Clip.antiAlias,
                //   color: tardyStatus.color,
                //   child: InkWell(
                //     onDoubleTap: () {
                //       Provider.of<WebSaleRequestDetailsPresenter>(context,
                //               listen: false)
                //           .updateDeliveryControlStatus(
                //         saleRequestId: saleRequest.SaleRequestId!,
                //         deliveryLotId:
                //             saleRequest.Products.first.DeliveryLoteNumber!,
                //         newStatus: isToDeliveryStatus == IsToDelivery.preparing
                //             ? IsToDelivery.ready
                //             : IsToDelivery.delivered,
                //       );
                //     },
                //     child: Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: Column(
                //         children: [

                //           const Divider(thickness: 0.1),
                //           // if (products.isEmpty)
                //           //   //!quando marca como pronto, salva o horário do campo DateHourOfDelivery. Mas quando marca como preparando de novo, esse campo
                //           //   //!continua igual. Esse campo é usado para identificar os produtos que foram solicitados após a última entrega
                //           //   Row(
                //           //     children: [
                //           //       Expanded(
                //           //           child: Text(
                //           //         R.string.msgAllProductsAreDelivered,
                //           //         style: const TextStyle(color: Colors.red),
                //           //       )),
                //           //       const Icon(
                //           //         Icons.error,
                //           //         color: Colors.red,
                //           //       ),
                //           //     ],
                //           //   ),
                //           ProductsItems(
                //             products: products,
                //             isPreparingColumn:
                //                 isToDeliveryStatus == IsToDelivery.preparing,
                //             tardyStatus: tardyStatus,
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // );
              },
            ),
          ),
        ],
      ),
    );
  }
}
