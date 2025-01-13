import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/models.dart';
import '../../pages.dart';

class PrintProductsTestButton extends StatelessWidget {
  const PrintProductsTestButton({super.key});

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    return IconButton(
      onPressed: () async {
        await printedProductsPresenter.newPrintProducts(
            closePage: () {
              Navigator.of(context).pop();
            },
            columnsParameters: [
              PrintParametersModel(
                alignCenter: true,
                bold: true,
                text: "Time",
                width: 2,
              ),
              PrintParametersModel(
                alignCenter: false,
                bold: false,
                text: "Product",
                width: 4,
              ),
              PrintParametersModel(
                alignCenter: true,
                bold: true,
                text: "Price",
                width: 2,
              ),
              PrintParametersModel(
                alignCenter: true,
                bold: true,
                text: "Quantity",
                width: 2,
              ),
              PrintParametersModel(
                alignCenter: true,
                bold: true,
                text: "total",
                width: 2,
              ),
            ]);
      },
      icon: Icon(
        Icons.print_disabled,
      ),
    );
  }
}
