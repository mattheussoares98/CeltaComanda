import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/helpers/helpers.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class PaymentButtons extends StatelessWidget {
  const PaymentButtons({super.key});

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);
    PaymentPresenter paymentPresenter = Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return Center(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${R.string.total}: ${printedProductsPresenter.printedProducts!.TotalLiquid.toDouble().toString().toBrazilianNumber()}"
                    .addBrazilianCoin(),
                style: TextStyle(
                  fontSize: getStringSize(context) * 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 20,
                ),
                child: Text(
                  R.string.selectPaymentOption,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                    fontSize: getStringSize(context),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await paymentPresenter.doPayment(
                    longAmountValue: printedProductsPresenter
                        .printedProducts!.TotalLiquid
                        .toDouble(),
                    portionQuantity: 1,
                    paymentMode: PaymentMode.pix,
                    commandNumber: homePresenter.commandNumber.toString(),
                  );
                },
                child: Text(
                  "PIX",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: getStringSize(context),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  await paymentPresenter.doPayment(
                      longAmountValue: printedProductsPresenter
                          .printedProducts!.TotalLiquid
                          .toDouble(),
                      portionQuantity: 1,
                      paymentMode: PaymentMode.debit,
                      commandNumber: homePresenter.commandNumber.toString());
                },
                child: Text(
                  R.string.debit.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: getStringSize(context),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  await paymentPresenter.doPayment(
                    longAmountValue: printedProductsPresenter
                        .printedProducts!.TotalLiquid
                        .toDouble(),
                    portionQuantity: 1,
                    paymentMode: PaymentMode.credit,
                    commandNumber: homePresenter.commandNumber.toString(),
                  );
                },
                child: Text(
                  R.string.cashCredit.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: getStringSize(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
