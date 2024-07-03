import 'package:flutter/material.dart';

import '../../../../ui/helpers/helpers.dart';

class QuantityText extends StatelessWidget {
  final String quantity;
  const QuantityText({
    required this.quantity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "Quantidade: ${quantity.toBrazilianNumber()}",
      style: TextStyle(
        fontSize: hasMinWidth(context) ? 23 : 12,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}
