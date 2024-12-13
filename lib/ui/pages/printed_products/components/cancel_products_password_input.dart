import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/usecases/usecases.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

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
    HomePresenter homePresenter = Provider.of(context, listen: false);

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
          fontSize: StringSize.size,
        ),
        hintStyle: TextStyle(
          fontSize: StringSize.size,
        ),
        labelText: "Senha do usuário",
        hintText: "Senha do usuário",
        suffixIcon: homePresenter.isGeneratingVersionToRede
            ? null
            : IconButton(
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
