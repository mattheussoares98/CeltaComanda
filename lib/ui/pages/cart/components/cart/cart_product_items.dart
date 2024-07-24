import 'package:flutter/material.dart';

import '../../../pages.dart';

class CartProductsItems extends StatelessWidget {
  final List<CartProductsViewModel> cartProducts;
  const CartProductsItems({
    required this.cartProducts,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cartProducts.length,
        itemBuilder: (context, index) {
          return CartProductItem(
            cartProduct: cartProducts[index],
            index: index,
            maxWidth: constraints.maxWidth,
          );
        },
      );
    });
  }
}
