import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../data/usecases/usecases.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class PasswordInput extends StatelessWidget {
  final FocusNode passwordFocusNode;
  final TextEditingController passwordController;
  final Future Function() updateCommandData;

  const PasswordInput({
    required this.passwordFocusNode,
    required this.passwordController,
    required this.updateCommandData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CameraBarcodeScanner cameraBarcodeScanner = CameraBarcodeScanner();
    HomePresenter homePresenter = Provider.of(context, listen: false);

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
        await updateCommandData();
      },
      decoration: InputDecoration(
        suffixIcon: homePresenter.isGeneratingVersionToRede
            ? null
            : IconButton(
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
