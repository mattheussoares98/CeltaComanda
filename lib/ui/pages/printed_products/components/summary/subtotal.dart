import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class Subtotal extends StatelessWidget {
  const Subtotal({super.key});

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    return Row(
      children: [
        Expanded(
          child: Text(
            R.string.subtotal,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: getStringSize(context)),
          ),
        ),
        Expanded(
          child: Text(
            printedProductsPresenter.printedProducts!.TotalLiquid
                .toDouble()
                .toString()
                .toBrazilianNumber()
                .addBrazilianCoin(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: getStringSize(context),
            ),
          ),
        ),
      ],
    );
  }
}
