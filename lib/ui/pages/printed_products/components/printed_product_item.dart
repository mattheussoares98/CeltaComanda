import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../presentation/presenters/presenters.dart';
import '../../../components/components.dart';
import '../../pages.dart';

class PrintedProductItem extends StatelessWidget {
  final ProductsViewModel product;
  final String quantity;
  final String totalLiquid;
  final String? comments;
  final String saleRequestProductId;
  const PrintedProductItem({
    required this.product,
    required this.quantity,
    required this.totalLiquid,
    required this.comments,
    required this.saleRequestProductId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    GetxPrintedProductsPresenter presenter =
        Provider.of(context, listen: false);
    final TextEditingController personalizedCodeController =
        TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Row(
      children: [
        // ImageWidget(product: product),
        ProductDetails(
            nameComplete: product.NameComplete,
            name: product.Name,
            eanCode: product.EanCode,
            plu: product.PriceLookupCode,
            comments: comments,
            saleRetailPraticed: product.SaleRetailPraticed,
            totalLiquid: totalLiquid,
            quantity: quantity,
            onPressedAddQuantity: null,
            onPressedReduceQuantity: null,
            isPrintedProducts: true,
            onPressedRemoveProduct: () async {
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) {
                    return AlertDialog(
                      key: const Key("AlertDialogSearchCommand"),
                      title: const Text(
                        "Validar permissão de cancelamento",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      content: Form(
                        key: formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            TextFormField(
                              autofocus: true,
                              // onChanged: (value) {},
                              validator: (value) {
                                if (value == null) {
                                  return "Digite o código do usuário";
                                } else if (int.tryParse(value) == null) {
                                  return "Número inválido";
                                }
                                return null;
                              },
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10)
                              ],
                              controller: personalizedCodeController,
                              decoration: const InputDecoration(
                                labelText: "Código do usuário",
                                hintText: "Código do usuário",
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              // autofocus: true,
                              // onChanged: (value) {},
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Digite a senha do usuário";
                                }
                                return null;
                              },
                              controller: passwordController,
                              decoration: const InputDecoration(
                                labelText: "Senha do usuário",
                                hintText: "Senha do usuário",
                              ),
                              obscureText: true,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            bool isValid = formKey.currentState!.validate();
                            if (!isValid) return;

                            Navigator.of(context).pop();
                            await presenter.removeProduct(
                              password: passwordController.text,
                              personalizedCode:
                                  int.parse(personalizedCodeController.text),
                              saleRequestProductId: saleRequestProductId,
                            );
                          },
                          child: const Text("Validar usuário"),
                        )
                      ],
                    );
                  });
            }),
      ],
    );
  }
}
