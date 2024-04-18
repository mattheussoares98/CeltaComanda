import 'package:flutter/material.dart';

import '../../../components/components.dart';

class ProductDetailsCartIcon extends StatelessWidget {
  final void Function()? goToCartPage;
  const ProductDetailsCartIcon({
    required this.goToCartPage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.grey,
      child: CartIcon(
        goToCartPage: goToCartPage,
        color: Colors.white,
      ),
    );
  }
}
