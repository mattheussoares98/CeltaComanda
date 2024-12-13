import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';

class Subtotal extends StatelessWidget {
  final double totalLiquid;
  const Subtotal({
    required this.totalLiquid,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            R.string.subtotal,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: StringSize.size),
          ),
        ),
        Expanded(
          child: Text(
            totalLiquid
                .toDouble()
                .toString()
                .toBrazilianNumber()
                .addBrazilianCoin(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: StringSize.size,
            ),
          ),
        ),
      ],
    );
  }
}
