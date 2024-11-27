import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class TotalSummary extends StatelessWidget {
  const TotalSummary({super.key});

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(R.string.subtotal),
                  FittedBox(
                    child: Text(
                      printedProductsPresenter
                          .getSubtotal(printedProductsPresenter.printed)
                          .toDouble()
                          .toString()
                          .toBrazilianNumber()
                          .addBrazilianCoin(),
                      style: textStyle(),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(R.string.serviceChargeAbbreviated),
                  FittedBox(
                    child: Text(
                      printedProductsPresenter
                          .getServiceChargeValue(
                              printedProductsPresenter.printed)
                          .toDouble()
                          .toString()
                          .toBrazilianNumber()
                          .addBrazilianCoin(),
                      style: textStyle(),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(R.string.total),
                  FittedBox(
                    child: Text(
                      printedProductsPresenter
                          .getTotalLiquid(printedProductsPresenter.printed)
                          .toDouble()
                          .toString()
                          .toBrazilianNumber()
                          .addBrazilianCoin(),
                      style: textStyle(),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (printedProductsPresenter.peopleQuantity > 1)
          Row(
            children: [
              Expanded(
                child: Text(
                  "${R.string.totalByPerson} (${printedProductsPresenter.peopleQuantity})",
                  style: textStyle(),
                ),
              ),
              Text(
                "${printedProductsPresenter.getTotalLiquid(printedProductsPresenter.printed) / printedProductsPresenter.peopleQuantity}"
                    .toDouble()
                    .toString()
                    .toBrazilianNumber()
                    .addBrazilianCoin(),
                style: textStyle(),
              ),
            ],
          ),
      ],
    );
  }
}
