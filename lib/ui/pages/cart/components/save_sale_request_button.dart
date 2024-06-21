import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../pages.dart';

class SaveSaleRequestButton extends StatelessWidget {
  const SaveSaleRequestButton({super.key});

  static _addProducts({
    required CartPresenter cartPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required BuildContext context,
    required int? tableNumber,
    String? commandNumber,
  }) async {
    bool isUpdated = await cartPresenter.saveProducts(
      printedProductsPresenter: printedProductsPresenter,
      tableNumber: tableNumber,
      commandNumber: commandNumber,
    );

    if (isUpdated) {
      Future.delayed(Duration.zero, () {
        showAlertMessage(
          context,
          "Os produtos foram inseridos na comanda com sucesso",
        );
      });
    }
  }

  static bool isGeneratingVersionToRede = true;

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(context, listen: true);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    TextEditingController tableNumberController = TextEditingController();
    TextEditingController commandNumberController = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: ElevatedButton(
          onPressed: () async {
            if (isGeneratingVersionToRede) {
              notificationDialog(
                context: context,
                titleMessage: "Insira o número da comanda",
                content: TextFormField(
                  controller: commandNumberController,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  decoration: const InputDecoration(
                    label: Text("Comanda"),
                    hintText: "Exp: 001",
                  ),
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return "Digite o número da comanda";
                    } else if (int.tryParse(value!) == null) {
                      return "Número inválido";
                    } else if (value.length < 3) {
                      value = value.padLeft(3, "0");
                    }
                    return null;
                  },
                ),
                onPress: () async {
                  await _addProducts(
                    cartPresenter: cartPresenter,
                    printedProductsPresenter: printedProductsPresenter,
                    context: context,
                    tableNumber: 0,
                    commandNumber: commandNumberController.text,
                  );
                },
              );
            } else {
              notificationDialog(
                context: context,
                titleMessage: "Adicionar número da bandeira/mesa",
                cancelMessage: "Pular",
                confirmMessage: "Confirmar bandeira",
                closeDialogOnConfirmPress: false,
                onCancelPress: () async {
                  await _addProducts(
                    cartPresenter: cartPresenter,
                    context: context,
                    printedProductsPresenter: printedProductsPresenter,
                    tableNumber: null,
                  );
                },
                onPress: () async {
                  bool? isValid = formKey.currentState?.validate();

                  if (isValid == true) {
                    Navigator.of(context).pop();
                    await _addProducts(
                      cartPresenter: cartPresenter,
                      context: context,
                      printedProductsPresenter: printedProductsPresenter,
                      tableNumber: int.tryParse(tableNumberController.text),
                    );
                  }
                },
                content: Row(
                  children: [
                    const Expanded(child: SizedBox()),
                    Expanded(
                      child: Form(
                        key: formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: TextFormField(
                          autofocus: true,
                          controller: tableNumberController,
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            counterText: "",
                          ),
                          validator: (value) {
                            if (int.tryParse(value!) == null) {
                              return "Número inválido";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                  ],
                ),
              );
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                'Confirmar',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Builder(builder: (context) {
                return Text(cartPresenter.totalSaleRequestTempPrice);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
