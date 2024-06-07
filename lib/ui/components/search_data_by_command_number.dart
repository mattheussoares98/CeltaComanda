import 'package:flutter/material.dart';

import '../pages/pages.dart';

class SearchDataByCommandNumber extends StatelessWidget {
  final HomePresenter homePresenter;
  final Future Function() loadCommandData;
  final String emptyMessage;
  const SearchDataByCommandNumber({
    required this.homePresenter,
    required this.loadCommandData,
    required this.emptyMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = AppBar().preferredSize.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final usableScreenHeight = screenHeight - appBarHeight - statusBarHeight;

    return SizedBox(
      height: usableScreenHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            emptyMessage,
            textAlign: TextAlign.center,
          ),
          TextButton.icon(
            onPressed: () async {
              _showDialogLoadCommandData(
                context: context,
                homePresenter: homePresenter,
                loadCommandData: () async {
                  await loadCommandData();
                },
              );
            },
            icon: const Icon(Icons.search),
            label: const Text(
              "Consultar dados da comanda",
              textAlign: TextAlign.center,
              style: TextStyle(
                  // fontSize: 25,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

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

void _showDialogLoadCommandData({
  required BuildContext context,
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
