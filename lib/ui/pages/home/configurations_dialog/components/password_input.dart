import 'package:flutter/material.dart';

import '../../../../helpers/helpers.dart';

class PasswordInput extends StatelessWidget {
  final FocusNode passwordFocusNode;
  final TextEditingController passwordController;
  final Future<void> Function() goToConfigurationsPage;

  const PasswordInput({
    required this.passwordFocusNode,
    required this.passwordController,
    required this.goToConfigurationsPage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: passwordFocusNode,
      controller: passwordController,
      obscureText: true,
      autofocus: false,
      onFieldSubmitted: (_) async {
        await goToConfigurationsPage();
      },
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
