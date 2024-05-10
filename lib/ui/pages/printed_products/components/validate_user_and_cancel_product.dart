import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../ui/pages/pages.dart';

Future<void> _removeProduct({
  required BuildContext context,
  required GlobalKey<FormState> formKey,
  required TextEditingController personalizedCodeController,
  required TextEditingController passwordController,
  required PrintedProductsPresenter printedProductsPresenter,
  required ExpansibleGroupsPresenter expansibleGroupsPresenter,
  required SaleRequestTempPresenter saleRequestTempPresenter,
  required HomePresenter homePresenter,
  required String saleRequestProductId,
}) async {
  bool isValid = formKey.currentState!.validate();
  if (!isValid) return;

  Navigator.of(context).pop();
  await printedProductsPresenter.removeProduct(
    password: passwordController.text,
    personalizedCode: int.parse(personalizedCodeController.text),
    saleRequestProductId: saleRequestProductId,
    expansibleGroupsPresenter: expansibleGroupsPresenter,
    printedProductsPresenter: printedProductsPresenter,
    saleRequestTempPresenter: saleRequestTempPresenter,
    homePresenter: homePresenter,
  );

  personalizedCodeController.clear();
  passwordController.clear();
}

void validateUserAndCancelProduct({
  required BuildContext context,
  required GlobalKey<FormState> formKey,
  required TextEditingController personalizedCodeController,
  required TextEditingController passwordController,
  required PrintedProductsPresenter printedProductsPresenter,
  required ExpansibleGroupsPresenter expansibleGroupsPresenter,
  required SaleRequestTempPresenter saleRequestTempPresenter,
  required HomePresenter homePresenter,
  required String saleRequestProductId,
  required FocusNode passwordFocus,
  required FocusNode userFocus,
}) {
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              key: const Key("AlertDialogSearchCommand"),
              title: const Text(
                "Validar permissão de cancelamento",
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
                        if (passwordController.text.isEmpty) {
                          formKey.currentState!.validate();
                          FocusScope.of(context).requestFocus(passwordFocus);
                          return;
                        }

                        await _removeProduct(
                          context: context,
                          formKey: formKey,
                          personalizedCodeController:
                              personalizedCodeController,
                          passwordController: passwordController,
                          printedProductsPresenter: printedProductsPresenter,
                          saleRequestProductId: saleRequestProductId,
                          expansibleGroupsPresenter: expansibleGroupsPresenter,
                          saleRequestTempPresenter: saleRequestTempPresenter,
                          homePresenter: homePresenter,
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
                    await _removeProduct(
                      context: context,
                      formKey: formKey,
                      personalizedCodeController: personalizedCodeController,
                      passwordController: passwordController,
                      printedProductsPresenter: printedProductsPresenter,
                      saleRequestProductId: saleRequestProductId,
                      expansibleGroupsPresenter: expansibleGroupsPresenter,
                      saleRequestTempPresenter: saleRequestTempPresenter,
                      homePresenter: homePresenter,
                    );
                  },
                  child: const Text("Validar usuário"),
                )
              ],
            ),
          ),
        );
      });
}
