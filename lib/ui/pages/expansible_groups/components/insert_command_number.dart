import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:flutter/material.dart';

class InsertCommandNumber extends StatelessWidget {
  final ExpansibleGroupsPresenter presenter;
  const InsertCommandNumber({
    required this.presenter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = AppBar().preferredSize.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final usableScreenHeight = screenHeight - appBarHeight - statusBarHeight;

    final TextEditingController textController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return SizedBox(
      height: usableScreenHeight,
      child: Center(
        child: TextButton(
          onPressed: () {
            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  return AlertDialog(
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
                          await presenter
                              .verifyCommandAvailable(textController.text);
                        },
                        child: const Text("Consultar"),
                      )
                    ],
                  );
                });
          },
          child: const Text(
            "Informe o número da comanda",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
            ),
          ),
        ),
      ),
    );
  }
}
