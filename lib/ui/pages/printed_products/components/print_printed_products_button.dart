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
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return IconButton(
      onPressed: homePresenter.commandEntity!.commandNumber == null
          ? null
          : () async {
              // final bitmap =
              await printedProductsPresenter.printPrintedProducts(
                commandNumber:
                    homePresenter.commandEntity!.commandNumber!.toInt(),
                pdvNumber: homePresenter.commandEntity!.pdv!.PdvNumber!.toInt(),
              );

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
      icon: Icon(Icons.print),
    );
  }
}
