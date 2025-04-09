import 'package:flutter/material.dart';

import '../../ui/helpers/convert/convert.dart';

class UpdateQuantity extends StatelessWidget {
  final int quantity;
  final void Function() reduceQuantity;
  final void Function() addQuantity;
  final TextEditingController? quantityController;
  final bool? canWriteQuantity;
  const UpdateQuantity({
    required this.quantity,
    required this.reduceQuantity,
    required this.addQuantity,
    this.canWriteQuantity,
    this.quantityController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _CircleAvatar(
          isAddingQuantity: false,
          updateQuantity: quantity <= 1 ? null : reduceQuantity,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColorDark,
            maxRadius: 70,
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Text(
                quantity.toString().toBrazilianNumber(0),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                ),
              ),
            ),
          ),
        ),
        _CircleAvatar(
          updateQuantity: addQuantity,
          isAddingQuantity: true,
        ),
      ],
    );
  }
}

class _CircleAvatar extends StatelessWidget {
  final void Function()? updateQuantity;
  final bool isAddingQuantity;

  const _CircleAvatar({
    required this.updateQuantity,
    required this.isAddingQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: updateQuantity,
      child: CircleAvatar(
        maxRadius: 40,
        backgroundColor: Theme.of(context).primaryColorLight,
        child: Icon(isAddingQuantity ? Icons.add : Icons.remove),
      ),
    );
  }
}
