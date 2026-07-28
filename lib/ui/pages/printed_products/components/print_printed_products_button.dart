import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../pages.dart';

class PrintPrintedProductsButton extends StatelessWidget {
  const PrintPrintedProductsButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter = Provider.of(context);
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return IconButton(
      onPressed: printedProductsPresenter.printed == null
          ? null
          : () async {
              // final bitmap =
              final commandNum = homePresenter.commandEntity?.commandNumber?.toInt();
              final pdvNum = homePresenter.commandEntity?.pdv?.PdvNumber?.toInt();
              if (commandNum != null && pdvNum != null) {
                await printedProductsPresenter.printPrintedProducts(
                  commandNumber: commandNum,
                  pdvNumber: pdvNum,
                );
              }

              //PARA TESTAR COMO VAI SAIR A IMPRESSÃo
              // if (bitmap != null) {
              //   notificationDialog(
              //     context: context,
              //     showCancelAndConfirmMessage: false,
              //     showCloseAction: true,
              //     titleMessage: "",
              //     content: Image.memory(bitmap),
              //     onPress: () async {},
              //   );
              // }
            },
      icon: const Icon(Icons.print),
    );
  }
}
