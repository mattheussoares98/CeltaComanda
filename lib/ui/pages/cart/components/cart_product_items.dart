import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/helpers/sizes/sizes.dart';
import '../../pages.dart';

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
          if (hasMinWidth(context)) {
            return LandscapeCartProductItem(
              cartProduct: cartProduct,
              index: index,
              maxWidth: constraints.maxWidth,
            );
          } else {
            return PortraitCartProductItem(
              cartProduct: cartProduct,
              index: index,
              maxWidth: constraints.maxWidth,
            );
          }
        },
      );
    });
  }
}
