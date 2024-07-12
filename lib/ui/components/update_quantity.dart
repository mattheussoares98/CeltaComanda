import 'package:flutter/material.dart';

import '../../ui/helpers/helpers.dart';

class UpdateQuantity extends StatelessWidget {
  final double productQuantity;
  final void Function()? onPressedReduceQuantity;
  final void Function()? onPressedAddQuantity;
  final bool showDeleteIcon;
  final double iconSize;
  const UpdateQuantity({
    required this.productQuantity,
    required this.onPressedReduceQuantity,
    required this.onPressedAddQuantity,
    required this.showDeleteIcon,
    required this.iconSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                showDeleteIcon ? Icons.delete : Icons.remove,
                color: showDeleteIcon
                    ? Colors.red
                    : Theme.of(context).primaryColor,
                size: iconSize,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Text(
                  productQuantity.toString().toBrazilianNumber(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: hasMinWidth(context) ? 20 : 15,
                  ),
                ),
              ),
              Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.primary,
                size: iconSize,
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: onPressedReduceQuantity,
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: onPressedAddQuantity,
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
