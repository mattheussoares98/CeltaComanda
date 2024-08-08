import 'package:flutter/material.dart';

import '../../../../data/usecases/usecases.dart';
import '../../../helpers/helpers.dart';

class PasswordInput extends StatelessWidget {
  final FocusNode passwordFocusNode;
  final TextEditingController passwordController;
  final Future Function() updateCommandNumber;

  const PasswordInput({
    required this.passwordFocusNode,
    required this.passwordController,
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
          return R.string.msgWritePassword;
        }
        return null;
      },
      onFieldSubmitted: (_) async {
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
        hintText: R.string.password,
        labelText: R.string.password,
      ),
    );
  }
}
