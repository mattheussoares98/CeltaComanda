import 'package:flutter/material.dart';

import '../../ui/helpers/convert/convert.dart';

class UpdateQuantity extends StatelessWidget {
  final int quantity;
  final Function() reduceQuantity;
  final Function() addQuantity;
  const UpdateQuantity({
    required this.quantity,
    required this.reduceQuantity,
    required this.addQuantity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget getCircleAvatar({
      required bool isAddingQuantity,
      required void Function()? updateQuantity,
    }) {
      return InkWell(
        onTap: updateQuantity,
        child: CircleAvatar(
          maxRadius: 40,
          backgroundColor: Theme.of(context).primaryColorLight,
          child: Icon(isAddingQuantity ? Icons.add : Icons.remove),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        getCircleAvatar(
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
        getCircleAvatar(
          isAddingQuantity: true,
          updateQuantity: addQuantity,
        ),
      ],
    );
  }
}
