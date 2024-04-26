import 'package:flutter/material.dart';

class UpdateProductQuantity extends StatelessWidget {
  final String quantity;
  final void Function()? onPressedReduceQuantity;
  final void Function()? onPressedAddQuantity;
  const UpdateProductQuantity({
    required this.quantity,
    required this.onPressedReduceQuantity,
    required this.onPressedAddQuantity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[300],
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.delete,
              ),
              iconSize: 20,
              visualDensity: VisualDensity.compact,
              onPressed: onPressedReduceQuantity,
              color: const Color(0xFFFF5963),
            ),
            Text(quantity),
            IconButton(
              icon: const Icon(
                Icons.add,
              ),
              iconSize: 20,
              visualDensity: VisualDensity.compact,
              onPressed: onPressedAddQuantity,
              color: const Color(0xFFFF5963),
            ),
          ],
        ),
      ),
    );
  }
}
