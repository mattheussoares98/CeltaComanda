import 'package:flutter/material.dart';

import '../../../../data/usecases/usecases.dart';

class PasswordInput extends StatelessWidget {
  final FocusNode passwordFocusNode;
  final TextEditingController passwordController;
  final Function() changeIsUpdatingCommandNumber;
  final Future Function() updateCommandNumber;

  const PasswordInput({
    required this.passwordFocusNode,
    required this.passwordController,
    required this.changeIsUpdatingCommandNumber,
    required this.updateCommandNumber,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CameraBarcodeScanner cameraBarcodeScanner = CameraBarcodeScanner();

    return TextFormField(
      focusNode: passwordFocusNode,
      controller: passwordController,
      obscureText: true,
      validator: (value) {
        if (value?.isEmpty == true) {
          return "Digite a senha";
        }
        return null;
      },
      onFieldSubmitted: (_) async {
        changeIsUpdatingCommandNumber();
        await updateCommandNumber();
      },
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () async {
            final password = await cameraBarcodeScanner.read();
            if (password.isNotEmpty) {
              passwordController.text = password;
            }
          },
          icon: const Icon(Icons.camera_alt),
        ),
        hintText: "Senha",
        labelText: "Senha",
      ),
    );
  }
}
