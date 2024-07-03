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
        SizedBox(width: MediaQuery.of(context).size.width > 500 ? 30 : 2),
        InkWell(
          onTap: onPressedReduceQuantity,
          child: Icon(
            showDeleteIcon ? Icons.delete : Icons.remove,
            color: showDeleteIcon ? Colors.red : Theme.of(context).primaryColor,
            size: MediaQuery.of(context).size.width > 500 ? 40 : 30,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Text(
            productQuantity.toString().toBrazilianNumber(),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width > 500 ? 30 : 17),
          ),
        ),
        InkWell(
          onTap: onPressedAddQuantity,
          child: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.primary,
            size: MediaQuery.of(context).size.width > 500 ? 40 : 30,
          ),
        ),
        const SizedBox(width: 1),
      ],
    );
  }
}
