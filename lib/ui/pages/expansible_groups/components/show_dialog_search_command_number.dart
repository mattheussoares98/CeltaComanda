import 'package:flutter/material.dart';

import '../../pages.dart';

Future<void> _validateFormAndSearchCommand({
  required GlobalKey<FormState> formKey,
  required BuildContext context,
  required ExpansibleGroupsPresenter presenter,
  required PrintedProductsPresenter printedProductsPresenter,
  required SaleRequestTempPresenter saleRequestTempPresenter,
  required TextEditingController textController,
}) async {
  bool isValid = formKey.currentState!.validate();
  if (!isValid) return;

  Navigator.of(context).pop();
  await presenter.load(
    commandNumber: textController.text,
    printedProductsPresenter: printedProductsPresenter,
    saleRequestTempPresenter: saleRequestTempPresenter,
  );
}

void showDialogSearchCommandNumber({
  required BuildContext context,
  required ExpansibleGroupsPresenter presenter,
  required PrintedProductsPresenter printedProductsPresenter,
  required SaleRequestTempPresenter saleRequestTempPresenter,
}) {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController textController = TextEditingController();

  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          key: const Key("AlertDialogSearchCommand"),
          content: Form(
            key: formKey,
            child: TextFormField(
              onFieldSubmitted: (_) async {
                await _validateFormAndSearchCommand(
                  formKey: formKey,
                  context: context,
                  presenter: presenter,
                  printedProductsPresenter: printedProductsPresenter,
                  saleRequestTempPresenter: saleRequestTempPresenter,
                  textController: textController,
                );
              },
              autofocus: true,
              onChanged: (value) {},
              validator: (value) {
                if (value?.isEmpty == true || value?.length != 3) {
                  return "Digite 3 números";
                }
                return null;
              },
              maxLength: 3,
              controller: textController,
              decoration: const InputDecoration(
                labelText: "Exemplo: 001",
                hintText: "Exemplo: 001",
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          title: const Text(
            "Número da comanda",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await _validateFormAndSearchCommand(
                  formKey: formKey,
                  context: context,
                  presenter: presenter,
                  printedProductsPresenter: printedProductsPresenter,
                  saleRequestTempPresenter: saleRequestTempPresenter,
                  textController: textController,
                );
              },
              child: const Text("Consultar"),
            )
          ],
        );
      });
}
