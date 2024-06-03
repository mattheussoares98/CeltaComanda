import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../../ui/components/components.dart';
import '../../pages.dart';

class SaveSaleRequestButton extends StatelessWidget {
  const SaveSaleRequestButton({super.key});

  @override
  Widget build(BuildContext context) {
    SaleRequestTempPresenter saleRequestTempPresenter =
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
                      focusNode: commentsFocusNode,
                      controller: commandNumberController,
                      maxLines: null,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(3, 10, 3, 3),
                        label: Text("Insira o número da comanda"),
                        hintText: "Número da comanda",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onPress: () async {
              bool isUpdated = await saleRequestTempPresenter
                  .saveProducts(commandNumberController.text);

              if (isUpdated) {
                Future.delayed(Duration.zero, () {
                  showAlertMessage(
                    context,
                    "Os produtos foram inseridos na comanda com sucesso",
                  );
                });
              }
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
