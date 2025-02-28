import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/helpers/sizes/sizes.dart';
import '../../pages.dart';

class CartProductsItems extends StatefulWidget {
  const CartProductsItems({
    super.key,
  });

  @override
  State<CartProductsItems> createState() => _CartProductsItemsState();
}

class _CartProductsItemsState extends State<CartProductsItems> {
  int? selectedIndexComment;

  void updateSelectedIndexComment(int index) {
    if (selectedIndexComment == index) {
      setState(() {
        selectedIndexComment = null;
      });
    } else {
      setState(() {
        selectedIndexComment = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(context);

    return LayoutBuilder(builder: (context, constraints) {
      return ListView.builder(
        shrinkWrap: true,
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
              selectedIndex: selectedIndexComment,
              updateSelectedIndex: () {
                updateSelectedIndexComment(index);
              },
            );
          }
        },
      );
    });
  }
}
