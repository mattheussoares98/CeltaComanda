import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/helpers/helpers.dart';
import '../../../../main/builders/builders.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class PaymentButtons extends StatelessWidget {
  const PaymentButtons({super.key});

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter = Provider.of(context);
    PaymentPresenter paymentPresenter = Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${R.string.total}: ${printedProductsPresenter.printedProducts!.TotalLiquid.toDouble().toString().toBrazilianNumber()} R\$",
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
        if (homePresenter.isGeneratingVersionToRede)
          Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  await paymentPresenter.callPayment(
                    longAmountValue: printedProductsPresenter
                        .printedProducts!.TotalLiquid
                        .toDouble(),
                    portionQuantity: 1,
                    paymentMode: PaymentMode.pix,
                    homePresenter: homePresenter,
                  );
                },
                child: Text(
                  "PIX",
                  style: _buttonStyle(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ElevatedButton(
                  onPressed: () async {
                    await paymentPresenter.callPayment(
                      longAmountValue: printedProductsPresenter
                          .printedProducts!.TotalLiquid
                          .toDouble(),
                      portionQuantity: 1,
                      paymentMode: PaymentMode.debit,
                      homePresenter: homePresenter,
                    );
                  },
                  child: Text(
                    R.string.debit.toUpperCase(),
                    style: _buttonStyle(context),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ElevatedButton(
                  onPressed: () async {
                    await paymentPresenter.callPayment(
                      longAmountValue: printedProductsPresenter
                          .printedProducts!.TotalLiquid
                          .toDouble(),
                      portionQuantity: 1,
                      paymentMode: PaymentMode.credit,
                      homePresenter: homePresenter,
                    );
                  },
                  child: Text(
                    R.string.cashCredit.toUpperCase(),
                    style: _buttonStyle(context),
                  ),
                ),
              ),
            ],
          ),
        if (EnterpriseDataBuilder.enterpriseDataEntity?.useCovenant == true)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ElevatedButton(
              onPressed: () {
                paymentPresenter.goToCovenantPage();
              },
              child: Text(
                R.string.covenant.toUpperCase(),
                style: _buttonStyle(context),
              ),
            ),
          ),
      ],
    );
  }
}

TextStyle _buttonStyle(BuildContext context) => TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: getStringSize(context),
    );
