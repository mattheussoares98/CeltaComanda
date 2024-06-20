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
  }) async {
    bool isUpdated = await cartPresenter.saveProducts(
      printedProductsPresenter: printedProductsPresenter,
      tableNumber: tableNumber,
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

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    TextEditingController tableNumberController = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: ElevatedButton(
          onPressed: () async {
            notificationDialog(
              context: context,
              titleMessage: "Adicionar número da mesa",
              onCancelPress: () async {
                await _addProducts(
                  cartPresenter: cartPresenter,
                  context: context,
                  printedProductsPresenter: printedProductsPresenter,
                  tableNumber: null,
                );
              },
              cancelMessage: "Pular",
              confirmMessage: "Confirmar mesa",
              closeDialogOnConfirmPress: false,
              content: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  autofocus: true,
                  controller: tableNumberController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration: const InputDecoration(
                    counterText: "",
                  ),
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return "Número inválido";
                    } else if (int.tryParse(value!) == null) {
                      return "Número inválido";
                    }
                    return null;
                  },
                ),
              ),
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
            );
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
