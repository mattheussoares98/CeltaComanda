import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../pages.dart';

void writeCommandNumber({
  required BuildContext context,
  required bool isInsertingProductsInCommand,
}) {
  GlobalKey<FormState> commandKey = GlobalKey<FormState>();
  TextEditingController commandNumberController = TextEditingController();
  MenuPresenter menuPresenter = Provider.of(context, listen: false);
  CartPresenter cartPresenter = Provider.of(context, listen: false);
  HomePresenter homePresenter = Provider.of(context, listen: false);
  PrintedProductsPresenter printedProductsPresenter =
      Provider.of(context, listen: false);

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
              onFieldSubmitted: (value) async {
                Navigator.of(context).pop();
                await _onPress(
                  context: context,
                  cartPresenter: cartPresenter,
                  printedProductsPresenter: printedProductsPresenter,
                  homePresenter: homePresenter,
                  menuPresenter: menuPresenter,
                  commandNumber: commandNumberController.text,
                  commandKey: commandKey,
                  isInsertingProductsInCommand: isInsertingProductsInCommand,
                );
              },
            ),
          ),
        ),
        const Expanded(child: SizedBox()),
      ],
    ),
    onPress: () async {
      await _onPress(
        context: context,
        cartPresenter: cartPresenter,
        printedProductsPresenter: printedProductsPresenter,
        homePresenter: homePresenter,
        menuPresenter: menuPresenter,
        commandNumber: commandNumberController.text,
        commandKey: commandKey,
        isInsertingProductsInCommand: isInsertingProductsInCommand,
      );
    },
  );
}

Future<void> _onPress({
  required BuildContext context,
  required CartPresenter cartPresenter,
  required PrintedProductsPresenter printedProductsPresenter,
  required HomePresenter homePresenter,
  required MenuPresenter menuPresenter,
  required String commandNumber,
  required GlobalKey<FormState> commandKey,
  required bool isInsertingProductsInCommand,
}) async {
  bool? isValid = commandKey.currentState?.validate();

  if (isValid == false || isValid == null) {
    return;
  }

  if (isInsertingProductsInCommand) {
    bool isUpdated = await cartPresenter.saveProducts(
      printedProductsPresenter: printedProductsPresenter,
      tableNumber: 0,
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
  } else {
    await printedProductsPresenter.loadCommandData(
      printedProductsPresenter: printedProductsPresenter,
      cartPresenter: cartPresenter,
      menuPresenter: menuPresenter,
      homePresenter: homePresenter,
      clearPermissionToCancelProducts: true,
      isRemovingProduct: false,
      isGeneratingVersionToRede: cartPresenter.isGeneratingVersionToRede,
      commandNumber: commandNumber,
    );
  }
}
