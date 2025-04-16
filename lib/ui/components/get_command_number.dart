import 'package:flutter/material.dart';

import '../../ui/helpers/helpers.dart';
import '../../main/builders/builders.dart';
import 'components.dart';

class GetCommandNumber {
  GetCommandNumber._();
  static final commandNumberController = TextEditingController();
  static final commandKey = GlobalKey<FormState>();
  static final focusNode = FocusNode();

  static Future<int?> get() async {
    int? commandNumber;

    void onSubmit() {
      bool? isValid = commandKey.currentState?.validate();
      if (isValid == true) {
        commandNumber = commandNumberController.text.toInt();
        commandNumberController.clear();
        Navigator.of(NavigatorKey.navigatorKey.currentState!.context).pop();
      } else {
        focusNode.requestFocus();
      }
    }

    await notificationDialog(
      context: NavigatorKey.navigatorKey.currentState!.context,
      titleMessage: R.string.msgInsertCommandNumber,
      confirmMessage: R.string.confirm,
      cancelMessage: R.string.cancel,
      closeDialogOnConfirmPress: false,
      onPress: () async {
        onSubmit();
      },
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
                maxLength: 2,
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
                  onSubmit();
                },
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );

    return commandNumber;
  }
}
