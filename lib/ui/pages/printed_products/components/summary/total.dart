import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class Total extends StatelessWidget {
  const Total({super.key});

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          R.string.total,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          printedProductsPresenter.totalLiquid
              .toDouble()
              .toString()
              .toBrazilianNumber()
              .addBrazilianCoin(),
          textAlign: TextAlign.end,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: getStringSize(context),
          ),
        ),
      ],
    );
  }
}
