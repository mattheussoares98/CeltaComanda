import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../../components/components.dart';
import '../../pages.dart';

class SaveSaleRequestButton extends StatelessWidget {
  const SaveSaleRequestButton({
    super.key,
  });

  _addProducts({
    required CartPresenter cartPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required CommentsPresenter commentsPresenter,
    required BuildContext context,
    required HomePresenter homePresenter,
    required int? tableNumber,
    String? commandNumber,
  }) async {
    // cartPresenter.doCartToPrintedAnimation();
    // return;
    bool isUpdated = await cartPresenter.saveProducts(
      printedProductsPresenter: printedProductsPresenter,
      tableNumber: tableNumber,
      commandNumber: commandNumber,
      homePresenter: homePresenter,
      commentsPresenter: commentsPresenter,
    );

    if (isUpdated) {
      Future.delayed(Duration.zero, () {
        showAlertMessage(
          context,
          "O pedido foi enviado com sucesso",
        );
      });

      Future.delayed(Duration.zero, () {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(context, listen: true);
    HomePresenter homePresenter = Provider.of(context, listen: false);
    CommentsPresenter commentsPresenter = Provider.of(context, listen: false);
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
                commentsPresenter: commentsPresenter,
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
                commentsPresenter: commentsPresenter,
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
                  commentsPresenter: commentsPresenter,
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
