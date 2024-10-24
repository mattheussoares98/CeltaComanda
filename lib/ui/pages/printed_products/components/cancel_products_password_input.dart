import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class CancelProductsPasswordInput extends StatelessWidget {
  final FocusNode passwordFocus;
  final Future Function() validateUserAndPermissionToCancel;
  final TextEditingController passwordController;
  const CancelProductsPasswordInput({
    required this.passwordFocus,
    required this.validateUserAndPermissionToCancel,
    required this.passwordController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: passwordFocus,
      onFieldSubmitted: (_) async {
        await validateUserAndPermissionToCancel();
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Digite a senha do usuário";
        }
        return null;
      },
      controller: passwordController,
      decoration: InputDecoration(
        labelStyle: TextStyle(
          fontSize: getStringSize(context),
        ),
        hintStyle: TextStyle(
          fontSize: getStringSize(context),
        ),
        labelText: "Senha do usuário",
        hintText: "Senha do usuário",
      ),
      obscureText: true,
    );
  }
}
