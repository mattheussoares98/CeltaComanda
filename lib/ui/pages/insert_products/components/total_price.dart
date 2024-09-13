import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class TotalPrice extends StatelessWidget {
  final double totalLiquid;

  const TotalPrice({
    required this.totalLiquid,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 42,
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FittedBox(
              child: Text(
                R.string.total,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: getStringSize(context) * 1.2,
                ),
              ),
            ),
            FittedBox(
              child: Text(
                totalLiquid.toString().toBrazilianNumber().addBrazilianCoin(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: getStringSize(context) * 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
