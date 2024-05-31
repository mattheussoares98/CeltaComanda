import 'package:flutter/material.dart';

import '../pages/pages.dart';

Future<void> _validateFormAndUpdateCommandNumber({
  required GlobalKey<FormState> formKey,
  required BuildContext context,
  required HomePresenter homePresenter,
  required TextEditingController textController,
  required Future Function() loadCommandData,
}) async {
  bool isValid = formKey.currentState!.validate();
  if (!isValid) return;

  homePresenter.updateCommandNumber(textController.text);

  Navigator.of(context).pop();

  await loadCommandData();
}

void dialogLoadCommandData({
  required BuildContext context,
  required MenuPresenter menuPresenter,
  required PrintedProductsPresenter printedProductsPresenter,
  required SaleRequestTempPresenter saleRequestTempPresenter,
  required HomePresenter homePresenter,
  required Future Function() loadCommandData,
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
                await _validateFormAndUpdateCommandNumber(
                  formKey: formKey,
                  context: context,
                  homePresenter: homePresenter,
                  textController: textController,
                  loadCommandData: loadCommandData,
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
                await _validateFormAndUpdateCommandNumber(
                  formKey: formKey,
                  context: context,
                  homePresenter: homePresenter,
                  textController: textController,
                  loadCommandData: loadCommandData,
                );
              },
              child: const Text("Consultar"),
            )
          ],
        );
      });
}
