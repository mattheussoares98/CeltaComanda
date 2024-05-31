import 'package:flutter/material.dart';

import '../../ui/helpers/helpers.dart';

class UpdateQuantity extends StatelessWidget {
  final double productQuantity;
  final void Function()? onPressedReduceQuantity;
  final void Function()? onPressedAddQuantity;
  const UpdateQuantity({
    required this.productQuantity,
    required this.onPressedReduceQuantity,
    required this.onPressedAddQuantity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          key: const Key("IconButtonSubtractQuantity"),
          icon: const Icon(Icons.remove),
          iconSize: 20,
          visualDensity: VisualDensity.compact,
          onPressed: onPressedReduceQuantity,
          color: Theme.of(context).colorScheme.primary,
        ),
        Text(productQuantity.toString().toBrazilianNumber()),
        IconButton(
          icon: const Icon(
            Icons.add,
          ),
          iconSize: 20,
          visualDensity: VisualDensity.compact,
          onPressed: onPressedAddQuantity,
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }
}
