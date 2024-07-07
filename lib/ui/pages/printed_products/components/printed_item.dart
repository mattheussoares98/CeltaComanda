import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../../ui/components/components.dart';
import '../../../../ui/helpers/helpers.dart';
import '../../pages.dart';

class PrintedItem extends StatelessWidget {
  final PrintedViewModel printed;

  final GlobalKey<FormState> formKey;
  final TextEditingController personalizedCodeController;
  final TextEditingController passwordController;
  const PrintedItem({
    required this.printed,
    required this.formKey,
    required this.personalizedCodeController,
    required this.passwordController,
    super.key,
  });

  Future<void> _removeProduct({
    required PrintedProductsPresenter printedProductsPresenter,
    required MenuPresenter menuPresenter,
    required CartPresenter cartPresenter,
    required HomePresenter homePresenter,
    required String saleRequestProductId,
  }) async {
    await printedProductsPresenter.removeProduct(
      saleRequestProductId: saleRequestProductId,
      menuPresenter: menuPresenter,
      cartPresenter: cartPresenter,
      homePresenter: homePresenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: printed.Products.length,
              itemBuilder: (context, index) {
                final product = printed.Products[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: const Color.fromARGB(255, 220, 218, 218)),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 10,
                        color: Color(0x33000000),
                        offset: Offset(-3, -1),
                      )
                    ],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
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
                                menuPresenter: menuPresenter,
                                cartPresenter: cartPresenter,
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
                            printedProductsPresenter: printedProductsPresenter,
                          );
                        },
                        quantity: product.Quantity,
                        value: (product.TotalLiquid.toDouble() /
                                product.Quantity.toDouble())
                            .toString()
                            .toBrazilianNumber(),
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
                  ),
                );
              },
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
      ],
    );
  }
}
