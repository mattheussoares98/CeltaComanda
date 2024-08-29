import 'package:flutter/material.dart';

import '../../../../helpers/helpers.dart';

class UserPersonalizedCodeInput extends StatelessWidget {
  final FocusNode passwordFocusNode;
  final TextEditingController userController;
  const UserPersonalizedCodeInput({
    super.key,
    required this.passwordFocusNode,
    required this.userController,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: R.string.userCode,
        labelText: R.string.userCode,
      ),
    );
  }
}
