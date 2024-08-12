import 'package:flutter/material.dart';

import '../../../../data/usecases/usecases.dart';
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
    CameraBarcodeScanner cameraBarcodeScanner = CameraBarcodeScanner();

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
        suffixIcon: IconButton(
          onPressed: () async {
            final value = await cameraBarcodeScanner.read();
            if (value.isNotEmpty) {
              passwordController.text = value;
              await validateUserAndPermissionToCancel();
            }
          },
          icon: const Icon(
            Icons.camera_alt,
            size: 30,
          ),
        ),
      ),
      obscureText: true,
    );
  }
}
