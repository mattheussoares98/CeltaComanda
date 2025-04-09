import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class PaymentDetails extends StatelessWidget {
  const PaymentDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);
    PaymentPresenter paymentPresenter = Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return Column(
      children: [
        FittedBox(
          child: Text(
            "${R.string.total}: ${printedProductsPresenter.getTotalLiquid(printedProductsPresenter.printed).toDouble().toString().toBrazilianNumber()} R\$",
            style: TextStyle(
              fontSize: StringSize.size * 1.2,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (homePresenter.isGeneratingVersionToGetNet ||
            homePresenter.isGeneratingVersionToRede)
          Column(
            children: [
              FittedBox(
                child: Text(
                  "${R.string.totalPaid}: ${paymentPresenter.totalPaidValue.toString().toBrazilianNumber().addBrazilianCoin()}",
                  style: TextStyle(
                    fontSize: StringSize.size * 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FittedBox(
                child: Text(
                  "${R.string.missing} ${paymentPresenter.getTotalPendingValue(printedProductsPresenter).toString().toBrazilianNumber().addBrazilianCoin()}",
                  style: TextStyle(
                    fontSize: StringSize.size * 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 10,
          ),
          child: Text(
            R.string.selectPaymentOption,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
              fontSize: StringSize.size,
            ),
          ),
        ),
      ],
    );
  }
}
