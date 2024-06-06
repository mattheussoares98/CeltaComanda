import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../pages.dart';

class SaveSaleRequestButton extends StatelessWidget {
  const SaveSaleRequestButton({super.key});

  static _addProducts({
    required CartPresenter cartPresenter,
    required String commandNumber,
    required BuildContext context,
  }) async {
    bool isUpdated = await cartPresenter.saveProducts(commandNumber);

    if (isUpdated) {
      Future.delayed(Duration.zero, () {
        showAlertMessage(
          context,
          "Os produtos foram inseridos na comanda com sucesso",
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter =
        Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    TextEditingController commandNumberController = TextEditingController();
    FocusNode commentsFocusNode = FocusNode();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 40),
        ),
        onPressed: () async {
          if (printedProductsPresenter.printedProducts?.Comments != null) {
            commandNumberController.text =
                printedProductsPresenter.printedProducts!.Comments!;
          }
          notificationDialog(
            context: context,
            titleMessage: "Número da comanda",
            content: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  const Text(
                      "Consulte a comanda para verificar se ela está disponível"),
                  const SizedBox(height: 15),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 100,
                    ),
                    child: TextFormField(
                      autofocus: true,
                      focusNode: commentsFocusNode,
                      controller: commandNumberController,
                      maxLines: null,
                      maxLength: 3,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(3, 10, 3, 3),
                        label: Text("Insira o número da comanda"),
                        hintText: "Número da comanda",
                      ),
                      onFieldSubmitted: (value) async {
                        await _addProducts(
                          cartPresenter: cartPresenter,
                          commandNumber: commandNumberController.text,
                          context: context,
                        );
                      },
                      validator: (value) {
                        if (value?.isEmpty == true) {
                          return "Digite 3 números";
                        } else if (value!.length < 3) {
                          return "Digite 3 números";
                        } else if (int.tryParse(value) == null) {
                          return "Número inválido";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            onPress: () async {
              await _addProducts(
                cartPresenter: cartPresenter,
                commandNumber: commandNumberController.text,
                context: context,
              );
            },
          );
        },
        child: const Text(
          'Confirmar',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
