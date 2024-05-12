import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../ui/pages/pages.dart';

Future<void> _validateUserAndPermissionToCancelProducts({
  required BuildContext context,
  required GlobalKey<FormState> formKey,
  required PrintedProductsPresenter printedProductsPresenter,
  required TextEditingController personalizedCodeController,
  required TextEditingController passwordController,
}) async {
  bool isValid = formKey.currentState!.validate();
  if (!isValid) {
    return;
  }

  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  }

  await printedProductsPresenter.validateUserAndPermissionToCancelProducts(
    personalizedCode: int.parse(personalizedCodeController.text),
    password: passwordController.text,
  );
  personalizedCodeController.clear();
  passwordController.clear();
}

void validateUserAndCancelProductDialog({
  required BuildContext context,
  required GlobalKey<FormState> formKey,
  required TextEditingController personalizedCodeController,
  required TextEditingController passwordController,
  required PrintedProductsPresenter printedProductsPresenter,
}) {
  FocusNode passwordFocus = FocusNode();
  FocusNode userFocus = FocusNode();

  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              key: const Key("AlertDialogSearchCommand"),
              title: const Text(
                "Liberar cancelamento de itens",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              content: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      focusNode: userFocus,
                      autofocus: true,
                      onFieldSubmitted: (value) {
                        if (personalizedCodeController.text.isEmpty) {
                          formKey.currentState!.validate();
                          FocusScope.of(context).requestFocus(userFocus);
                          return;
                        }

                        FocusScope.of(context).requestFocus(passwordFocus);
                      },
                      // onChanged: (value) {},
                      validator: (value) {
                        if (value == null) {
                          return "Digite o código do usuário";
                        } else if (int.tryParse(value) == null) {
                          return "Número inválido";
                        }
                        return null;
                      },
                      inputFormatters: [LengthLimitingTextInputFormatter(10)],
                      controller: personalizedCodeController,
                      decoration: const InputDecoration(
                        labelText: "Código do usuário",
                        hintText: "Código do usuário",
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      focusNode: passwordFocus,
                      onFieldSubmitted: (_) async {
                        await _validateUserAndPermissionToCancelProducts(
                          context: context,
                          formKey: formKey,
                          printedProductsPresenter: printedProductsPresenter,
                          personalizedCodeController:
                              personalizedCodeController,
                          passwordController: passwordController,
                        );
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Digite a senha do usuário";
                        }
                        return null;
                      },
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: "Senha do usuário",
                        hintText: "Senha do usuário",
                      ),
                      obscureText: true,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    await _validateUserAndPermissionToCancelProducts(
                      context: context,
                      formKey: formKey,
                      printedProductsPresenter: printedProductsPresenter,
                      personalizedCodeController: personalizedCodeController,
                      passwordController: passwordController,
                    );
                  },
                  child: const Text("Liberar cancelamento"),
                )
              ],
            ),
          ),
        );
      });
}
