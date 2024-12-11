import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class SearchedProduct extends StatelessWidget {
  final ProductsViewModel product;
  final TextEditingController commandNumberController;
  final TextEditingController quantityController;
  const SearchedProduct({
    required this.product,
    required this.commandNumberController,
    required this.quantityController,
    super.key,
  });
  static final formKeyQuantity = GlobalKey<FormState>();
  static final formKeyCommandNumber = GlobalKey<FormState>();

  Future<void> addProduct(
    MenuPresenter menuPresenter,
    CartPresenter cartPresenter,
    HomePresenter homePresenter,
    PrintedProductsPresenter printedProductsPresenter,
    ProductsViewModel product,
  ) async {
    bool? isValid = formKeyQuantity.currentState?.validate();

    if (isValid == true) {
      await menuPresenter.addProductInSaleRequest(
        product: product,
        cartPresenter: cartPresenter,
        homePresenter: homePresenter,
        commandNumber: commandNumberController.text.isEmpty
            ? null
            : commandNumberController.text.toInt(),
        printedProductsPresenter: printedProductsPresenter,
        quantity: quantityController.text.toDouble(),
        dateTime: DateTime.now().toIso8601String(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    return Container(
      margin: EdgeInsets.only(top: 15),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Theme.of(context).primaryColorLight,
          )),
      width: double.infinity,
      child: Form(
        key: formKeyQuantity,
        child: Column(
          children: [
            Text(product.Name),
            Text(
              product.SaleRetailPraticed.toDouble()
                  .toString()
                  .toBrazilianNumber()
                  .addBrazilianCoin(),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: quantityController,
                    validator: (value) {
                      if (value == null || value.toDouble() == -1) {
                        return R.string.msgInvalidNumber;
                      }
                      return null;
                    },
                    decoration: formFieldDecoration(
                      context: context,
                      hintText: R.string.quantity,
                      labelText: R.string.quantity,
                      errorText: null,
                    ),
                  ),
                ),
                Form(
                  key: formKeyCommandNumber,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        commandNumberController.clear();

                        if (formKeyQuantity.currentState?.validate() != true) {
                          return;
                        }
                        if (homePresenter.commandEntity?.isFixedCommandNumber ==
                            false) {
                          await notificationDialog(
                            context: context,
                            titleMessage: R.string.msgWriteCommandNumber,
                            confirmMessage: R.string.confirm,
                            cancelMessage: R.string.cancel,
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextFormField(
                                  controller: commandNumberController,
                                  onFieldSubmitted: (_) async {
                                    bool? isValid = formKeyCommandNumber
                                        .currentState
                                        ?.validate();

                                    if (isValid == true) {
                                      await addProduct(
                                        menuPresenter,
                                        cartPresenter,
                                        homePresenter,
                                        printedProductsPresenter,
                                        product,
                                      );
                                    }
                                  },
                                  decoration: formFieldDecoration(
                                    context: context,
                                    hintText: R.string.commandNumber,
                                    labelText: R.string.commandNumber,
                                    errorText: null,
                                  ),
                                )
                              ],
                            ),
                            onPress: () async {
                              bool? isValid =
                                  formKeyCommandNumber.currentState?.validate();

                              if (isValid == true) {
                                await addProduct(
                                  menuPresenter,
                                  cartPresenter,
                                  homePresenter,
                                  printedProductsPresenter,
                                  product,
                                );
                              }
                            },
                          );
                        } else {
                          bool? isValid =
                              formKeyQuantity.currentState?.validate();

                          if (isValid == true) {
                            await addProduct(
                              menuPresenter,
                              cartPresenter,
                              homePresenter,
                              printedProductsPresenter,
                              product,
                            );
                          }
                        }
                      },
                      child: Text(
                        R.string.confirm,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
