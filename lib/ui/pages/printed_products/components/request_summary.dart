import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../../../ui/pages/pages.dart';
import '../../../helpers/helpers.dart';

class RequestSummary extends StatelessWidget {
  const RequestSummary({super.key});

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: true);

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color.fromARGB(255, 220, 218, 218)),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            color: Color(0x33000000),
            offset: Offset(-3, -1),
          )
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          R.string.serviceCharge,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: getStringSize(context)),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          printedProductsPresenter.serviceChargeValue
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
                  ),
                ],
              ),
            ),
            VerticalDivider(
              color: Theme.of(context).primaryColorLight,
              thickness: 1,
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    R.string.total,
                    textAlign: TextAlign.end,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
