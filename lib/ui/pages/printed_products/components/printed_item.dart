import 'package:clean_celta_mobile/ui/components/components.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../pages.dart';

class PrintedItem extends StatelessWidget {
  final PrintedViewModel printed;
  const PrintedItem({
    required this.printed,
    super.key,
  });

  Future<void> _removeProduct({
    required PrintedProductsPresenter printedProductsPresenter,
    required ExpansibleGroupsPresenter expansibleGroupsPresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
    required HomePresenter homePresenter,
    required String saleRequestProductId,
  }) async {
    await printedProductsPresenter.removeProduct(
      saleRequestProductId: saleRequestProductId,
      expansibleGroupsPresenter: expansibleGroupsPresenter,
      printedProductsPresenter: printedProductsPresenter,
      saleRequestTempPresenter: saleRequestTempPresenter,
      homePresenter: homePresenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);
    ExpansibleGroupsPresenter expansibleGroupsPresenter =
        Provider.of(context, listen: false);
    SaleRequestTempPresenter saleRequestTempPresenter =
        Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController personalizedCodeController =
        TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Column(
      children: [
        Container(
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
            padding: const EdgeInsets.fromLTRB(3, 3, 8, 0),
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
                        ProductDetails(
                          Product: product.Products,
                          onPressedRemoveProduct: () async {
                            notificationDialog(
                              context: context,
                              titleMessage: "Remover produto",
                              content: const Text(
                                "Deseja realmente remover o produto dos produtos solicitados?",
                                textAlign: TextAlign.center,
                              ),
                              onPress: () async {
                                await _removeProduct(
                                  printedProductsPresenter:
                                      printedProductsPresenter,
                                  expansibleGroupsPresenter:
                                      expansibleGroupsPresenter,
                                  saleRequestTempPresenter:
                                      saleRequestTempPresenter,
                                  homePresenter: homePresenter,
                                  saleRequestProductId:
                                      product.SaleRequestProductId,
                                );
                              },
                            );
                          },
                          validateUserAndCancelProducts: () {
                            validateUserAndCancelProductDialog(
                              context: context,
                              formKey: formKey,
                              personalizedCodeController:
                                  personalizedCodeController,
                              passwordController: passwordController,
                              printedProductsPresenter:
                                  printedProductsPresenter,
                            );
                          },
                          quantity: product.Quantity,
                          value: product.Value,
                          totalLiquid: product.TotalLiquid,
                          comments: product.Comments,
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
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: RequestSummary(
                    totalLiquid: printed.TotalLiquid,
                    comments: printed.Comments,
                  ),
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
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 40),
            ),
            onPressed: printedProductsPresenter.canCancelProducts
                ? null
                : () async {
                    validateUserAndCancelProductDialog(
                      context: context,
                      formKey: formKey,
                      personalizedCodeController: personalizedCodeController,
                      passwordController: passwordController,
                      printedProductsPresenter: printedProductsPresenter,
                    );
                  },
            child: const Text("Liberar cancelamento de itens"),
          ),
        ),
      ],
    );
  }
}
