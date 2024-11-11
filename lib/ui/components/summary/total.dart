import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';

class Total extends StatelessWidget {
  final double totalLiquid;
  const Total({
    required this.totalLiquid,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          R.string.total,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          totalLiquid
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
