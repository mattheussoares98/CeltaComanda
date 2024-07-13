import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../../components/components.dart';
import '../../pages.dart';

class SaveSaleRequestButton extends StatelessWidget {
  final PageController pageController;
  const SaveSaleRequestButton({
    required this.pageController,
    super.key,
  });

  _addProducts({
    required CartPresenter cartPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required BuildContext context,
    required HomePresenter homePresenter,
    required int? tableNumber,
    String? commandNumber,
  }) async {
    bool isUpdated = await cartPresenter.saveProducts(
      printedProductsPresenter: printedProductsPresenter,
      tableNumber: tableNumber,
      commandNumber: commandNumber,
      homePresenter: homePresenter,
    );

    if (isUpdated) {
      Future.delayed(Duration.zero, () {
        showAlertMessage(
          context,
          "Os produtos foram solicitados com sucesso",
        );
      });
      pageController.jumpToPage(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(context, listen: true);
    HomePresenter homePresenter = Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    TextEditingController tableNumberController = TextEditingController();
    GlobalKey<FormState> tableKey = GlobalKey<FormState>();

    return ElevatedButton(
      onPressed: () async {
        if (homePresenter.isFixedCommandNumber) {
          notificationDialog(
            context: context,
            titleMessage: "Enviar pedido",
            content: Text(
              "Ao confirmar, os produtos serão solicitados e em breve serão servidos",
              style: TextStyle(
                fontSize: hasMinWidth(context) ? 23 : 17,
              ),
            ),
            cancelMessage: "Voltar",
            confirmMessage: "Enviar",
            onPress: () async {
              await _addProducts(
                cartPresenter: cartPresenter,
                context: context,
                printedProductsPresenter: printedProductsPresenter,
                tableNumber: null,
                homePresenter: homePresenter,
              );
            },
          );
        } else {
          notificationDialog(
            context: context,
            titleMessage: "Adicionar número da bandeira/mesa",
            cancelMessage: "Pular",
            confirmMessage: "Confirmar bandeira",
            closeDialogOnConfirmPress: false,
            onCancelPress: () async {
              await _addProducts(
                cartPresenter: cartPresenter,
                context: context,
                printedProductsPresenter: printedProductsPresenter,
                tableNumber: null,
                homePresenter: homePresenter,
              );
            },
            onPress: () async {
              bool? isValid = tableKey.currentState?.validate();

              if (isValid == true) {
                Navigator.of(context).pop();
                await _addProducts(
                  cartPresenter: cartPresenter,
                  context: context,
                  printedProductsPresenter: printedProductsPresenter,
                  tableNumber: int.tryParse(tableNumberController.text),
                  homePresenter: homePresenter,
                );
              }
            },
            content: Row(
              children: [
                const Expanded(child: SizedBox()),
                Expanded(
                  child: Form(
                    key: tableKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: TextFormField(
                      autofocus: true,
                      controller: tableNumberController,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        counterText: "",
                      ),
                      validator: (value) {
                        if (int.tryParse(value!) == null) {
                          return "Número inválido";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          );
        }
      },
      child: FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FittedBox(
              child: Text(
                'Enviar pedido',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: hasMinWidth(context) ? 23 : 16,
                ),
              ),
            ),
            SizedBox(width: hasMinWidth(context) ? 100 : 5),
            FittedBox(
              child: Text(
                cartPresenter.totalSaleRequestTempPrice,
                style: TextStyle(
                  fontSize: hasMinWidth(context) ? 23 : 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
