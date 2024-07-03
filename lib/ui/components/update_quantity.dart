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
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: onPressedReduceQuantity,
            child: Icon(
              showDeleteIcon ? Icons.delete : Icons.remove,
              color:
                  showDeleteIcon ? Colors.red : Theme.of(context).primaryColor,
              size: hasMinWidth(context) ? 30 : 20,
            ),
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
          InkWell(
            onTap: onPressedAddQuantity,
            child: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.primary,
              size: hasMinWidth(context) ? 30 : 20,
            ),
          ),
          const SizedBox(width: 1),
        ],
      ),
    );
  }
}
