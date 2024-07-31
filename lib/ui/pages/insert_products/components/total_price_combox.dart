import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';
class TotalPriceCombox extends StatelessWidget {
  final double totalLiquid;

  const TotalPriceCombox({
    required this.totalLiquid,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              "Total",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Text(
              totalLiquid.toString().toBrazilianNumber().addBrazilianCoin(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: getStringSize(context) * 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
