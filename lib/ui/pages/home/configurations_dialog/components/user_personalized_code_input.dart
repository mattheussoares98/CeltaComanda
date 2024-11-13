import 'package:flutter/material.dart';

import '../../../../helpers/helpers.dart';

class UserPersonalizedCodeInput extends StatelessWidget {
  final FocusNode passwordFocusNode;
  final FocusNode userCodeFocusNode;
  final TextEditingController userController;
  const UserPersonalizedCodeInput({
    super.key,
    required this.passwordFocusNode,
    required this.userCodeFocusNode,
    required this.userController,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: userCodeFocusNode,
      autofocus: true,
      onFieldSubmitted: (_) {
        passwordFocusNode.requestFocus();
      },
      controller: userController,
      validator: (value) {
        if (value?.isEmpty == true) {
          return R.string.msgWriteUserCode;
        }
        return null;
      },
      keyboardType: TextInputType.numberWithOptions(decimal: false),
      decoration: InputDecoration(
        hintText: R.string.userCode,
        labelText: R.string.userCode,
      ),
    );
  }
}
