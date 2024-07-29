import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../pages.dart';

class CartProductsItems extends StatelessWidget {
  const CartProductsItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(context);

    return LayoutBuilder(builder: (context, constraints) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cartPresenter.cartProducts.length,
        itemBuilder: (context, index) {
          final cartProduct = cartPresenter.cartProducts[index];

          if (cartProduct.Product.childsComposition != null) {
            return const Text("Isso aqui é um combo");
          }

          return CartProductItem(
            cartProduct: cartProduct,
            index: index,
            maxWidth: constraints.maxWidth,
          );
        },
      );
    });
  }
}
