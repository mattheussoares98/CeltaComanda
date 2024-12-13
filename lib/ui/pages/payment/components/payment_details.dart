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
        Text(
          "${R.string.total}: ${printedProductsPresenter.getTotalLiquid(printedProductsPresenter.printed).toDouble().toString().toBrazilianNumber()} R\$",
          style: TextStyle(
            fontSize: StringSize.size * 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (homePresenter.isGeneratingVersionToGetNet ||
            homePresenter.isGeneratingVersionToRede)
          Column(
            children: [
              Text(
                "${R.string.totalPaid}: ${paymentPresenter.totalPaidValue.toString().toBrazilianNumber().addBrazilianCoin()}",
                style: TextStyle(
                  fontSize: StringSize.size * 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${R.string.missing} ${paymentPresenter.getTotalPendingValue(printedProductsPresenter).toString().toBrazilianNumber().addBrazilianCoin()}",
                style: TextStyle(
                  fontSize: StringSize.size * 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
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
              fontSize: StringSize.size,
            ),
          ),
        ),
      ],
    );
  }
}
