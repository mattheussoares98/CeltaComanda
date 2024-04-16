import 'package:flutter/material.dart';

class CartIcon extends StatelessWidget {
  final void Function()? goToCartPage;
  final Color? color;
  const CartIcon({
    this.color = Colors.grey,
    required this.goToCartPage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const Key("CartIcon"),
      onPressed: goToCartPage,
      icon: Icon(
        Icons.shopping_cart_outlined,
        color: color,
        size: 24,
      ),
    );
  }
}
