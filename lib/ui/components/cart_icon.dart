import 'package:flutter/material.dart';

class CartIcon extends StatelessWidget {
  final void Function()? goToCartPage;
  const CartIcon({
    required this.goToCartPage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const Key("CartIcon"),
      onPressed: goToCartPage,
      icon: const Icon(
        Icons.shopping_cart_rounded,
        color: Colors.red,
        shadows: [
          Shadow(
            offset: Offset(1, 1),
            blurRadius: 2.0,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
