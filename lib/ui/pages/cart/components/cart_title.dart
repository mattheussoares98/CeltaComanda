import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class CartTitle extends StatelessWidget {
  const CartTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Container(
        width: double.infinity,
        color: Theme.of(context).primaryColorDark,
        child: Center(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            R.string.cart.toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: StringSize.size,
            ),
          ),
        )),
      ),
    );
  }
}
