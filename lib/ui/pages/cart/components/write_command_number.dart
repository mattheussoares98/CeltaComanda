import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../pages.dart';

void writeCommandNumber({
  required CartPresenter cartPresenter,
  required PrintedProductsPresenter printedProductsPresenter,
  required BuildContext context,
  required HomePresenter homePresenter,
}) {
  GlobalKey<FormState> commandKey = GlobalKey<FormState>();
  TextEditingController commandNumberController = TextEditingController();

  notificationDialog(
    context: context,
    titleMessage: "Insira o número da comanda",
    confirmMessage: "Confirmar",
    cancelMessage: "Cancelar",
    content: Row(
      children: [
        const Expanded(child: SizedBox()),
        Expanded(
          flex: 4,
          child: Form(
            key: commandKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormField(
              autofocus: true,
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
                } else if (value!.length < 3) {
                  return "Digite 3 números";
                } else if (int.tryParse(value) == null) {
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
    onPress: () async {
      await _addProducts(
        cartPresenter: cartPresenter,
        printedProductsPresenter: printedProductsPresenter,
        context: context,
        tableNumber: 0,
        commandNumber: commandNumberController.text,
        homePresenter: homePresenter,
      );
    },
  );
}

_addProducts({
  required CartPresenter cartPresenter,
  required PrintedProductsPresenter printedProductsPresenter,
  required BuildContext context,
  required HomePresenter homePresenter,
  required int? tableNumber,
  String? commandNumber,
}) async {
  bool isUpdated = await cartPresenter.saveProducts(
    printedProductsPresenter: printedProductsPresenter,
    tableNumber: tableNumber,
    commandNumber: commandNumber,
    homePresenter: homePresenter,
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
