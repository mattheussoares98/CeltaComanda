import 'package:flutter/material.dart';

import '../../../../ui/helpers/helpers.dart';

class PriceText extends StatelessWidget {
  final double quantity;
  const PriceText({
    required this.quantity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      quantity.toString().toBrazilianNumber().addBrazilianCoin(),
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
        fontSize: hasMinWidth(context) ? 23 : 15,
      ),
    );
  }
}
