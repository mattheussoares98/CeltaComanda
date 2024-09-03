import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class QuantityAndPrice extends StatelessWidget {
  final String quantity;
  final String totalLiquid;
  const QuantityAndPrice({
    required this.quantity,
    required this.totalLiquid,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "${R.string.quantityAbbreviated} $quantity ",
                style: TextStyle(
                  fontSize: getStringSize(context) * 0.8,
                  fontWeight: FontWeight.w300,
                ),
              ),
              // InkWell(
              //   onTap: printedProductsPresenter.canCancelProducts
              //       ? onPressedRemoveProduct
              //       : validateUserAndCancelProducts,
              //   child: Icon(
              //     Icons.delete,
              //     color: printedProductsPresenter.canCancelProducts
              //         ? Colors.red
              //         : Colors.grey,
              //     size: 30,
              //   ),
              // ),
            ],
          ),
        ),
        FittedBox(
          child: Text(
            totalLiquid.addBrazilianCoin(),
            style: TextStyle(
              fontSize: getStringSize(context) * 0.8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
