import 'package:flutter/material.dart';

import '../../../../helpers/helpers.dart';

class PasswordInput extends StatelessWidget {
  final FocusNode passwordFocusNode;
  final TextEditingController passwordController;

  const PasswordInput({
    required this.passwordFocusNode,
    required this.passwordController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: passwordFocusNode,
      controller: passwordController,
      obscureText: true,
      validator: (value) {
        if (value?.isEmpty == true) {
          return R.string.msgWritePassword;
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: R.string.password,
        labelText: R.string.password,
      ),
    );
  }
}
