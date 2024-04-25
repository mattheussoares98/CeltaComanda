import 'package:flutter/material.dart';

import '../../pages.dart';

void showDialogSearchCommandNumber({
  required BuildContext context,
  required ExpansibleGroupsPresenter presenter,
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
            // autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormField(
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
          title: const Text("Consultar comanda"),
          actions: [
            TextButton(
              onPressed: () async {
                bool isValid = formKey.currentState!.validate();
                if (!isValid) return;

                Navigator.of(context).pop();
                await presenter.load(textController.text);
              },
              child: const Text("Consultar"),
            )
          ],
        );
      });
}
