import 'package:flutter/material.dart';

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
  if (formKey.currentState!.validate() != true) {
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
                    UserInput(
                      userFocus: userFocus,
                      passwordFocus: passwordFocus,
                      personalizedCodeController: personalizedCodeController,
                      formKey: formKey,
                    ),
                    const SizedBox(height: 15),
                    CancelProductsPasswordInput(
                      passwordFocus: passwordFocus,
                      validateUserAndPermissionToCancel: () async {
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
                      passwordController: passwordController,
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
                      fontSize: StringSize.size,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      });
}
