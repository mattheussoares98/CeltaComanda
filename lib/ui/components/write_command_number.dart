import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../main/builders/builders.dart';
import 'components.dart';
import '../helpers/helpers.dart';
import '../pages/pages.dart';

enum OnWriteCommand {
  saveProducts,
  loadCommandData,
  loadPrintedProducts,
}

void writeCommandNumber({
  required BuildContext context,
  required OnWriteCommand onWriteCommandAction,
}) {
  GlobalKey<FormState> commandKey = GlobalKey<FormState>();
  TextEditingController commandNumberController = TextEditingController();
  MenuPresenter menuPresenter = Provider.of(context, listen: false);
  CartPresenter cartPresenter = Provider.of(context, listen: false);
  HomePresenter homePresenter = Provider.of(context, listen: false);
  ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter =
      Provider.of(context, listen: false);
  PrintedProductsPresenter printedProductsPresenter =
      Provider.of(context, listen: false);
  PaymentPresenter paymentPresenter = Provider.of(context, listen: false);
  InsertProductPresenter insertProductPresenter =
      Provider.of(context, listen: false);
  FocusNode focusNode = FocusNode();

  notificationDialog(
    context: context,
    titleMessage: R.string.msgInsertCommandNumber,
    confirmMessage: R.string.confirm,
    cancelMessage: R.string.cancel,
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
              decoration: InputDecoration(
                label: Text(R.string.command),
                hintText: "Exp: 1",
              ),
              validator: (value) {
                if (value?.isEmpty == true) {
                  return R.string.msgWriteCommandNumber;
                } else if (int.tryParse(value!) == null) {
                  return R.string.msgInvalidNumber;
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
                    onWriteCommand: onWriteCommandAction,
                    focusNode: focusNode,
                    paymentPresenter: paymentPresenter,
                    expansibleGroupFromProductPresenter:
                        expansibleGroupFromProductPresenter,
                    insertProductPresenter: insertProductPresenter,
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
        insertProductPresenter: insertProductPresenter,
        context: context,
        cartPresenter: cartPresenter,
        printedProductsPresenter: printedProductsPresenter,
        homePresenter: homePresenter,
        menuPresenter: menuPresenter,
        commandNumber: commandNumberController.text,
        commandKey: commandKey,
        onWriteCommand: onWriteCommandAction,
        focusNode: focusNode,
        paymentPresenter: paymentPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
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
  required ExpansibleGroupFromProductPresenter
      expansibleGroupFromProductPresenter,
  required InsertProductPresenter insertProductPresenter,
}) async {
  bool? isValid = commandKey.currentState?.validate();

  if (isValid == false || isValid == null) {
    focusNode.requestFocus();
    return;
  }
  Navigator.of(context).pop();

  if (onWriteCommand == OnWriteCommand.saveProducts) {
    bool isUpdated = await cartPresenter.saveProducts(
      insertProductPresenter: insertProductPresenter,
      printedProductsPresenter: printedProductsPresenter,
      tableNumber: 0,
      commandNumber: commandNumber,
      homePresenter: homePresenter,
      expansibleGroupFromProductPresenter: expansibleGroupFromProductPresenter,
    );

    if (isUpdated) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Navigator.of(NavigatorKey.navigatorKey.currentState?.context ?? context)
            .pop();
        showAlertMessage(
          context,
          R.string.msgRequestSentSuccessfully,
        );
      });
    }
  } else if (onWriteCommand == OnWriteCommand.loadCommandData) {
    await homePresenter.loadCommandData(
      menuPresenter: menuPresenter,
      printedProductsPresenter: printedProductsPresenter,
      cartPresenter: cartPresenter,
      expansibleGroupFromProductPresenter: expansibleGroupFromProductPresenter,
      updateMenuCount: null,
    );
  } else {
    homePresenter.updateCommandNumber(commandNumber);
    await printedProductsPresenter.loadPrinted(homePresenter);
  }
}
