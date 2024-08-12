import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../data/usecases/usecases.dart';
import '../../../../ui/pages/pages.dart';
import '../../../helpers/helpers.dart';

Future<void> _validateUserAndPermissionToCancelProducts({
  required BuildContext context,
  required GlobalKey<FormState> formKey,
  required PrintedProductsPresenter printedProductsPresenter,
  required TextEditingController personalizedCodeController,
  required TextEditingController passwordController,
  required Function() callSetState,
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
  callSetState();
}

void validateUserAndCancelProductDialog({
  required BuildContext context,
  required GlobalKey<FormState> formKey,
  required TextEditingController personalizedCodeController,
  required TextEditingController passwordController,
  required PrintedProductsPresenter printedProductsPresenter,
  required Function() callSetState,
}) {
  FocusNode passwordFocus = FocusNode();
  FocusNode userFocus = FocusNode();
  CameraBarcodeScanner cameraBarcodeScanner = CameraBarcodeScanner();

  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              key: const Key("AlertDialogSearchCommand"),
              title: Text(
                R.string.liberateCancelProducts,
                textAlign: TextAlign.center,
                style: const TextStyle(
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
                          callSetState: callSetState,
                        );
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
                              Future.delayed(Duration.zero, () async {
                                await _validateUserAndPermissionToCancelProducts(
                                  context: context,
                                  formKey: formKey,
                                  printedProductsPresenter:
                                      printedProductsPresenter,
                                  personalizedCodeController:
                                      personalizedCodeController,
                                  passwordController: passwordController,
                                  callSetState: callSetState,
                                );
                              });
                            }
                          },
                          icon: const Icon(
                            Icons.camera_alt,
                            size: 30,
                          ),
                        ),
                      ),
                      obscureText: true,
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
                      callSetState: callSetState,
                    );
                  },
                  child: Text(
                    "Liberar cancelamento",
                    style: TextStyle(
                      fontSize: getStringSize(context),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      });
}
