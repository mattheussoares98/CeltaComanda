import 'package:flutter/material.dart';

import '../../../../data/models/models.dart';
import '../../../helpers/helpers.dart';

class TotalAddingAllPdvs extends StatelessWidget {
  final List<SaleMovementConcentratorModel> sales;
  const TotalAddingAllPdvs({
    required this.sales,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(R.string.total)),
        Text(
          sales
              .map((e) => e.TotalLiquid)
              .fold(0.0, (previous, element) {
                return previous += element!;
              })
              .toString()
              .toBrazilianNumber()
              .addBrazilianCoin(),
        ),
      ],
    );
  }
}
