import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';

class PasswordField extends StatelessWidget {
  final Future<void> Function() makeLogin;
  final TextEditingController passwordController;
  final FocusNode passwordFocusNode;
  const PasswordField({
    required this.makeLogin,
    required this.passwordController,
    required this.passwordFocusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      focusNode: passwordFocusNode,
      maxLength: 20,
      onFieldSubmitted: (_) async {
        await makeLogin();
      },
      decoration: formFieldDecoration(
        showCounterText: false,
        context: context,
        hintText: R.string.password,
        labelText: R.string.password,
        errorText: null,
      ),
    );
  }
}
