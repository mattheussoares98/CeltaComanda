import 'package:flutter/material.dart';

import '../../ui/helpers/helpers.dart';

class UpdateQuantity extends StatelessWidget {
  final double productQuantity;
  final void Function()? onPressedReduceQuantity;
  final void Function()? onPressedAddQuantity;
  final bool showDeleteIcon;
  const UpdateQuantity({
    required this.productQuantity,
    required this.onPressedReduceQuantity,
    required this.onPressedAddQuantity,
    required this.showDeleteIcon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: hasMinWidth(context) ? 30 : 2),
        InkWell(
          onTap: onPressedReduceQuantity,
          child: Icon(
            showDeleteIcon ? Icons.delete : Icons.remove,
            color: showDeleteIcon ? Colors.red : Theme.of(context).primaryColor,
            size: getIconSize(context),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Text(
            productQuantity.toString().toBrazilianNumber(),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: hasMinWidth(context) ? 30 : 17),
          ),
        ),
        InkWell(
          onTap: onPressedAddQuantity,
          child: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.primary,
            size: getIconSize(context),
          ),
        ),
        const SizedBox(width: 1),
      ],
    );
  }
}
