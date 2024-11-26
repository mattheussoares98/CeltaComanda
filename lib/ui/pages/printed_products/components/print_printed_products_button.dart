import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      onPressed: homePresenter.commandNumber == null
          ? null
          : () {
              printedProductsPresenter.goToPrintProductsPage();
            },
      icon: Icon(Icons.print),
    );
  }
}
