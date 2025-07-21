import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class PaymentDetails extends StatelessWidget {
  final double totalLiquid;
  final double totalPaidValue;
  final double totalPendingValue;
  const PaymentDetails({
    super.key,
    required this.totalLiquid,
    required this.totalPaidValue,
    required this.totalPendingValue,
  });

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return Column(
      children: [
        FittedBox(
          child: Text(
            "${R.string.total}: ${totalLiquid.toString().toBrazilianNumber()} R\$",
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
                  "${R.string.totalPaid}: ${totalPaidValue.toString().toBrazilianNumber().addBrazilianCoin()}",
                  style: TextStyle(
                    fontSize: StringSize.size * 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FittedBox(
                child: Text(
                  "${R.string.missing} ${totalPendingValue.toString().toBrazilianNumber().addBrazilianCoin()}",
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
