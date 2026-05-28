import 'package:clean_celta_mobile/presentation/helpers/app_platform.dart';
import 'package:flutter/widgets.dart';

import '../../../helpers/helpers.dart';

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
        if (activePlatform.isPaymentPlatform)
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
