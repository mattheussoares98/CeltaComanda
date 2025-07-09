import 'package:flutter/material.dart';

import '../../../../helpers/helpers.dart';

class ProductsHeader extends StatelessWidget {
  final int productFlex;
  final int quantityFlex;
  final int totalFlex;
  final int timeFlex;
  final double deleteButtonSize;
  const ProductsHeader({
    required this.productFlex,
    required this.quantityFlex,
    required this.totalFlex,
    required this.timeFlex,
    required this.deleteButtonSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: timeFlex,
              child: Text(
                R.string.time,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: StringSize.size,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              flex: productFlex,
              child: Text(
                R.string.products,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: StringSize.size,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              flex: quantityFlex,
              child: Text(
                R.string.quantityAbbreviated,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: StringSize.size,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              flex: totalFlex,
              child: Text(
                R.string.total.addBrazilianCoin(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: StringSize.size,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: deleteButtonSize, width: deleteButtonSize),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Divider(thickness: 0.2),
        ),
      ],
    );
  }
}
