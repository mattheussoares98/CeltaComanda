import 'package:flutter/material.dart';

import '../../pages.dart';

class CartProductsItems extends StatelessWidget {
  final List<CartProductsViewModel> cartProducts;
  const CartProductsItems({
    required this.cartProducts,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cartProducts.length,
          itemBuilder: (context, index) {
            final cartProduct = cartProducts[index];

            return CartProductItem(
              cartProduct: cartProduct,
              index: index,
            );
          },
        ),
      ],
    );
  }
}
