import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../pages.dart';

enum OnWriteCommand {
  saveProducts,
  loadCommandData,
  getPaymentAmmount,
}

void writeCommandNumber({
  required BuildContext context,
  required OnWriteCommand action,
}) {
  GlobalKey<FormState> commandKey = GlobalKey<FormState>();
  TextEditingController commandNumberController = TextEditingController();
  MenuPresenter menuPresenter = Provider.of(context, listen: false);
  CartPresenter cartPresenter = Provider.of(context, listen: false);
  HomePresenter homePresenter = Provider.of(context, listen: false);
  PrintedProductsPresenter printedProductsPresenter =
      Provider.of(context, listen: false);
  PaymentPresenter paymentPresenter = Provider.of(context, listen: false);
  FocusNode focusNode = FocusNode();

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
              focusNode: focusNode,
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
                bool? isValid = commandKey.currentState?.validate();
                if (isValid == true) {
                  await _onPress(
                    context: context,
                    cartPresenter: cartPresenter,
                    printedProductsPresenter: printedProductsPresenter,
                    homePresenter: homePresenter,
                    menuPresenter: menuPresenter,
                    commandNumber: commandNumberController.text,
                    commandKey: commandKey,
                    onWriteCommand: action,
                    focusNode: focusNode,
                    paymentPresenter: paymentPresenter,
                  );
                } else {
                  focusNode.requestFocus();
                }
              },
            ),
          ),
        ),
        const Expanded(child: SizedBox()),
      ],
    ),
    closeDialogOnConfirmPress: false,
    onPress: () async {
      await _onPress(
        context: context,
        cartPresenter: cartPresenter,
        printedProductsPresenter: printedProductsPresenter,
        homePresenter: homePresenter,
        menuPresenter: menuPresenter,
        commandNumber: commandNumberController.text,
        commandKey: commandKey,
        onWriteCommand: action,
        focusNode: focusNode,
        paymentPresenter: paymentPresenter,
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
  required OnWriteCommand onWriteCommand,
  required FocusNode focusNode,
  required PaymentPresenter paymentPresenter,
}) async {
  bool? isValid = commandKey.currentState?.validate();

  if (isValid == false || isValid == null) {
    focusNode.requestFocus();
    return;
  }
  Navigator.of(context).pop();

  if (onWriteCommand == OnWriteCommand.saveProducts) {
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
  } else if (onWriteCommand == OnWriteCommand.loadCommandData) {
    await printedProductsPresenter.loadCommandData(
      printedProductsPresenter: printedProductsPresenter,
      cartPresenter: cartPresenter,
      menuPresenter: menuPresenter,
      homePresenter: homePresenter,
      clearPermissionToCancelProducts: true,
      isRemovingProduct: false,
      writedCommandNumberForRedeVersion: commandNumber,
    );
  } else {
    await paymentPresenter.getTotalValue(
      homePresenter: homePresenter,
      writedCommandNumber: commandNumber,
      cartPresenter: cartPresenter,
      menuPresenter: menuPresenter,
      printedProductsPresenter: printedProductsPresenter,
    );
  }
}
