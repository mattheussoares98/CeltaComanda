import 'package:flutter/material.dart';

import 'components.dart';
import '../helpers/helpers.dart';

class PriceAndUpdateProductQuantity extends StatefulWidget {
  final void Function()? onPressedReduceQuantity;
  final void Function()? onPressedAddQuantity;
  final double productQuantity;
  final double price;
  final double totalLiquid;
  final bool showUpdateProductQuantity;
  final bool showItemPrice;
  const PriceAndUpdateProductQuantity({
    required this.onPressedReduceQuantity,
    required this.onPressedAddQuantity,
    required this.productQuantity,
    required this.price,
    required this.totalLiquid,
    required this.showUpdateProductQuantity,
    required this.showItemPrice,
    super.key,
  });

  @override
  State<PriceAndUpdateProductQuantity> createState() =>
      _PriceAndUpdateProductQuantityState();
}

class _PriceAndUpdateProductQuantityState
    extends State<PriceAndUpdateProductQuantity> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (widget.showItemPrice)
          Text(
            widget.price.toString().toBrazilianNumber().addBrazilianCoin(),
            style: TextStyle(
              fontSize: getStringSize(context),
            ),
          ),
        if (widget.showUpdateProductQuantity)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FittedBox(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[300],
                  ),
                  child: UpdateQuantity(
                    productQuantity: widget.productQuantity,
                    onPressedReduceQuantity: widget.onPressedReduceQuantity,
                    onPressedAddQuantity: widget.onPressedAddQuantity,
                    iconSize: getStringSize(context),
                  ),
                ),
              ),
              FittedBox(
                child: Text(
                  widget.totalLiquid
                      .toString()
                      .toBrazilianNumber()
                      .addBrazilianCoin(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                    fontSize: getStringSize(context),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
