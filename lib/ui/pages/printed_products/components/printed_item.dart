import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../presentation/presenters/presenters.dart';
import '../../pages.dart';

class PrintedItem extends StatelessWidget {
  final PrintedViewModel printed;
  const PrintedItem({
    required this.printed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    GetxPrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);
    GetxExpansibleGroupsPresenter expansibleGroupsPresenter =
        Provider.of(context, listen: false);
    GetxSaleRequestTempPresenter saleRequestTempPresenter =
        Provider.of(context, listen: false);
    GetxHomePresenter homePresenter = Provider.of(context, listen: false);

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController personalizedCodeController =
        TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
              blurRadius: 4, color: Color(0x33000000), offset: Offset(0, 2))
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: printed.Products.length,
              itemBuilder: (context, index) {
                final product = printed.Products[index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        // ImageWidget(product: product),
                        Expanded(
                          child: ProductDetails(
                            Product: product.Products,
                            onPressedRemoveProduct: () {
                              validateUserAndCancelProduct(
                                context: context,
                                formKey: formKey,
                                personalizedCodeController:
                                    personalizedCodeController,
                                passwordController: passwordController,
                                printedProductsPresenter:
                                    printedProductsPresenter,
                                saleRequestProductId:
                                    product.SaleRequestProductId,
                                passwordFocus: FocusNode(),
                                userFocus: FocusNode(),
                                expansibleGroupsPresenter:
                                    expansibleGroupsPresenter,
                                saleRequestTempPresenter:
                                    saleRequestTempPresenter,
                                homePresenter: homePresenter,
                              );
                            },
                            quantity: product.Quantity,
                            value: product.Value,
                            totalLiquid: product.TotalLiquid,
                            comments: product.Comments,
                          ),
                        ),
                      ],
                    ),
                    // Text("DateHourOfCreation ${product.DateHourOfCreation}"),
                    // Text(
                    //     "SaleRequestProductId ${product.SaleRequestProductId}"),
                    // Text("Quantity ${product.Quantity}"),
                    // Text("UserId ${product.UserId}"),
                    // Text("IsCancelled ${product.IsCancelled}"),
                    // Text("IsDelivered ${product.IsDelivered}"),
                    // Text("IsPrinted ${product.IsPrinted}"),
                    // Text("ProductionStatus ${product.ProductionStatus}"),
                    // Text(
                    //     "ProductInternalCodeOnErp ${product.ProductInternalCodeOnErp}"),
                    // Text("SaleRequestId ${product.SaleRequestId}"),
                  ],
                );
              },
            ),
            RequestSummary(
              totalLiquid: printed.TotalLiquid,
              comments: printed.Comments,
              canUpdateComment: false,
            ),
            // Text("Comanda: ${printed.PersonalizedCode}"),
            // Text("DateHourOfCreation: ${printed.DateHourOfCreation}"),
            // Text("DateOfCreation: ${printed.DateOfCreation}"),
            // Text("DeliveryControl: ${printed.DeliveryControl}"),
            // Text("EnterpriseId: ${printed.EnterpriseId}"),
            // Text("FlagOrigin: ${printed.FlagOrigin}"),
            // Text("FlagStatus: ${printed.FlagStatus}"),
            // Text("IsCancelled: ${printed.IsCancelled}"),
            // Text("IsUsing: ${printed.IsUsing}"),
            // Text("Peoples: ${printed.Peoples}"),
            // Text("RequestType: ${printed.RequestType}"),
            // Text("SaleRequestId: ${printed.SaleRequestId}"),
          ],
        ),
      ),
    );
  }
}
