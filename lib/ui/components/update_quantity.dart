import 'package:flutter/material.dart';

import '../../ui/helpers/helpers.dart';

class UpdateQuantity extends StatelessWidget {
  final double productQuantity;
  final void Function()? onPressedReduceQuantity;
  final void Function()? onPressedAddQuantity;
  final double iconSize;
  const UpdateQuantity({
    required this.productQuantity,
    required this.onPressedReduceQuantity,
    required this.onPressedAddQuantity,
    required this.iconSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            color: Theme.of(context).primaryColor,
            onPressed: onPressedReduceQuantity,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Text(
              productQuantity.toString().toBrazilianNumber(),
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
            onPressed: onPressedAddQuantity,
          ),
        ],
      ),
    );
  }
}
