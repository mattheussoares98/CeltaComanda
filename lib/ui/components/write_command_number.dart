import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../main/builders/builders.dart';
import 'components.dart';
import '../helpers/helpers.dart';
import '../pages/pages.dart';

enum ActionType {
  saveProducts,
  loadCommandData,
  loadPrintedProducts,
}

class WriteNumber {
  WriteNumber._();
  static final _commandNumberController = TextEditingController();
  static final _context = NavigatorKey.key.currentContext!;
  static final _focusNode = FocusNode();
  static final commandKey = GlobalKey<FormState>();

  static Future<String?> writeAndReturnNumber(
    ActionType? action, {
    required String title,
    required String label,
    required String hint,
    int? tableNumber,
    String? cancelMessage,
    int? maxLength,
  }) async {
    //is action is null, dont do anything

    CartPresenter cartPresenter = Provider.of(_context, listen: false);
    HomePresenter homePresenter = Provider.of(_context, listen: false);
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter =
        Provider.of(_context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(_context, listen: false);
    InsertProductPresenter insertProductPresenter =
        Provider.of(_context, listen: false);

    await notificationDialog(
      context: _context,
      titleMessage: title,
      confirmMessage: R.string.confirm,
      cancelMessage: cancelMessage ?? R.string.cancel,
      canPop: false,
      content: Row(
        children: [
          const Expanded(child: SizedBox()),
          Expanded(
            flex: 4,
            child: Form(
              key: commandKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Builder(builder: (context) {
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (!_focusNode.hasPrimaryFocus) {
                    _focusNode.requestFocus();
                  }
                });

                return TextFormField(
                  autofocus: false,
                  controller: _commandNumberController,
                  keyboardType: TextInputType.number,
                  maxLength: maxLength ?? 3,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    label: Text(label),
                    hintText: hint,
                  ),
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return R.string.msgWriteCommandNumber;
                    } else if (int.tryParse(value!) == null) {
                      return R.string.msgInvalidNumber;
                    } else if (int.parse(value) <= 0) {
                      return R.string.msgInvalidNumber;
                    }
                    return null;
                  },
                  onFieldSubmitted: (value) async {
                    bool? isValid = commandKey.currentState?.validate();
                    if (isValid == true) {
                      await _onPress(
                        tableNumber: tableNumber,
                        context: _context,
                        cartPresenter: cartPresenter,
                        printedProductsPresenter: printedProductsPresenter,
                        homePresenter: homePresenter,
                        commandNumber: _commandNumberController.text,
                        commandKey: commandKey,
                        action: action,
                        focusNode: _focusNode,
                        expansibleGroupFromProductPresenter:
                            expansibleGroupFromProductPresenter,
                        insertProductPresenter: insertProductPresenter,
                      );
                    } else {
                      _focusNode.requestFocus();
                    }
                  },
                );
              }),
            ),
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
      closeDialogOnConfirmPress: false,
      onPress: () async {
        await _onPress(
          tableNumber: tableNumber,
          insertProductPresenter: insertProductPresenter,
          context: _context,
          cartPresenter: cartPresenter,
          printedProductsPresenter: printedProductsPresenter,
          homePresenter: homePresenter,
          commandNumber: _commandNumberController.text,
          commandKey: commandKey,
          action: action,
          focusNode: _focusNode,
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter,
        );
      },
    );

    final commandNumberText = _commandNumberController.text;
    _commandNumberController.clear();

    if (int.tryParse(commandNumberText) != null &&
        int.parse(commandNumberText) > 0) {
      return commandNumberText;
    } else {
      return null;
    }
  }
}

Future<void> _onPress({
  required BuildContext context,
  required CartPresenter cartPresenter,
  required PrintedProductsPresenter printedProductsPresenter,
  required HomePresenter homePresenter,
  required String commandNumber,
  required GlobalKey<FormState> commandKey,
  required ActionType? action,
  required FocusNode focusNode,
  required ExpansibleGroupFromProductPresenter
      expansibleGroupFromProductPresenter,
  required InsertProductPresenter insertProductPresenter,
  required int? tableNumber,
}) async {
  bool? isValid = commandKey.currentState?.validate();

  if (isValid == false || isValid == null) {
    focusNode.requestFocus();
    return;
  }
  Navigator.of(context).pop();

  //is action is null, dont do anything
  if (action == ActionType.saveProducts) {
    try {
      bool isUpdated = await cartPresenter.saveProducts(
        insertProductPresenter: insertProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        commandNumber: commandNumber,
        homePresenter: homePresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      if (isUpdated) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          Navigator.of(NavigatorKey.key.currentState?.context ?? context).pop();
          snackBarMessage(
            context,
            R.string.msgRequestSentSuccessfully,
          );
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  } else if (action == ActionType.loadCommandData) {
    await homePresenter.loadCommandData(
      printedProductsPresenter: printedProductsPresenter,
      cartPresenter: cartPresenter,
      expansibleGroupFromProductPresenter: expansibleGroupFromProductPresenter,
    );
  } else if (action == ActionType.loadPrintedProducts) {
    final succeeds = await printedProductsPresenter.loadPrinted(
      commandNumber,
    );

    if (succeeds) {
      await homePresenter.updateCommandEntity(
        commandNumber: commandNumber,
        isFixedCommandNumber:
            homePresenter.commandEntity?.isFixedCommandNumber == true,
        pdv: homePresenter.commandEntity?.pdv,
      );
    }
  }
}
