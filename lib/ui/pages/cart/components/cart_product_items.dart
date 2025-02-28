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
  final commentController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
    focusNode.dispose();
  }

  void updateSelectedIndexComment(int index) {
    if (selectedIndexComment == index) {
      setState(() {
        selectedIndexComment = null;
      });
    } else {
      setState(() {
        Future.delayed(Duration.zero, () {
          focusNode.unfocus();
        });
        selectedIndexComment = index;

        Future.delayed(Duration(milliseconds: 100), () {
          focusNode.requestFocus();
        });
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
              focusNode: focusNode,
              productIndex: index,
              maxWidth: constraints.maxWidth,
              selectedIndex: selectedIndexComment,
              commentController: commentController,
              callSetState: () {
                setState(() {});
                updateSelectedIndexComment(index);
              },
              updateSelectedIndex: () {
                commentController.clear();
                updateSelectedIndexComment(index);
              },
            );
          }
        },
      );
    });
  }
}
