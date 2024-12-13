import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../helpers/helpers.dart';

class UserInput extends StatelessWidget {
  final FocusNode userFocus;
  final FocusNode passwordFocus;
  final TextEditingController personalizedCodeController;
  final GlobalKey<FormState> formKey;
  const UserInput({
    required this.userFocus,
    required this.passwordFocus,
    required this.personalizedCodeController,
    required this.formKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: userFocus,
      autofocus: true,
      onFieldSubmitted: (value) {
        if (personalizedCodeController.text.isEmpty) {
          formKey.currentState!.validate();
          FocusScope.of(context).requestFocus(userFocus);
          return;
        }

        FocusScope.of(context).requestFocus(passwordFocus);
      },
      validator: (value) {
        if (value == null) {
          return R.string.msgWriteUserCode;
        } else if (int.tryParse(value) == null) {
          return R.string.msgInvalidNumber;
        }
        return null;
      },
      inputFormatters: [LengthLimitingTextInputFormatter(10)],
      controller: personalizedCodeController,
      decoration: InputDecoration(
        labelText: R.string.userCode,
        hintText: R.string.userCode,
        labelStyle: TextStyle(fontSize: StringSize.size),
        hintStyle: TextStyle(fontSize: StringSize.size),
      ),
      keyboardType: TextInputType.number,
    );
  }
}
