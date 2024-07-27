import 'package:flutter/material.dart';

import '../helpers/helpers.dart';

class PriceAndUpdateProductQuantity extends StatefulWidget {
  final void Function()? onPressedReduceQuantity;
  final void Function()? onPressedAddQuantity;
  final int productQuantity;
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FittedBox(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[300],
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    color: Theme.of(context).primaryColor,
                    onPressed: widget.onPressedReduceQuantity,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Text(
                      widget.productQuantity.toString().toBrazilianNumber(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: hasMinWidth(context) ? 20 : 15,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    color: Theme.of(context).primaryColor,
                    onPressed: widget.onPressedAddQuantity,
                  ),
                ],
              ),
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
    );
  }
}
