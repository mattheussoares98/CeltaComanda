import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';

class CartProductsItems extends StatefulWidget {
  const CartProductsItems({
    super.key,
  });

  @override
  State<CartProductsItems> createState() => _CartProductsItemsState();
}

class _CartProductsItemsState extends State<CartProductsItems> {
  int? selectedProductIndexComment;
  int? selectedChildIndexComment;
  final commentController = TextEditingController();
  final commentFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
    commentFocusNode.dispose();
  }

  void updateSelectedProductIndexComment(int index) {
    if (selectedProductIndexComment == index) {
      setState(() {
        selectedProductIndexComment = null;
      });
    } else {
      setState(() {
        Future.delayed(Duration.zero, () {
          commentFocusNode.unfocus();
        });
        commentController.clear();
        selectedProductIndexComment = index;

        Future.delayed(Duration(milliseconds: 100), () {
          commentFocusNode.requestFocus();
        });
      });
    }
  }

  void updateSelectedChildIndexComment({
    required int childIndex,
    required int productIndex,
  }) {
    if (selectedChildIndexComment == childIndex) {
      setState(() {
        selectedProductIndexComment = null;
        selectedChildIndexComment = null;
      });
    } else {
      setState(() {
        Future.delayed(Duration.zero, () {
          commentFocusNode.unfocus();
        });
        commentController.clear();
        selectedProductIndexComment = productIndex;
        selectedChildIndexComment = childIndex;

        Future.delayed(Duration(milliseconds: 100), () {
          commentFocusNode.requestFocus();
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
          return LandscapeCartProductItem(
            removeSelectedIndex: () {
              Future.delayed(Duration.zero, () {
                selectedChildIndexComment = null;
                selectedProductIndexComment = null;
              });
              setState(() {});
            },
            selectedChildIndexComment: selectedChildIndexComment,
            cartProduct: cartProduct,
            commentFocusNode: commentFocusNode,
            productIndex: index,
            maxWidth: constraints.maxWidth,
            selectedIndex: selectedProductIndexComment,
            commentController: commentController,
            callSetState: () {
              setState(() {});
              updateSelectedProductIndexComment(index);
            },
            updateSelectedIndex: () {
              commentController.clear();
              updateSelectedProductIndexComment(index);
            },
            updateSelectedChildIndex: (childIndex) {
              updateSelectedChildIndexComment(
                childIndex: childIndex,
                productIndex: index,
              );
            },
          );
          // if (hasMinWidth(context)) {
          // } else {
          //   return PortraitCartProductItem(
          //     selectedChildIndexComment: selectedChildIndexComment,
          //     cartProduct: cartProduct,
          //     focusNode: commentFocusNode,
          //     productIndex: index,
          //     maxWidth: constraints.maxWidth,
          //     selectedIndex: selectedProductIndexComment,
          //     commentController: commentController,
          //     callSetState: () {
          //       setState(() {});
          //       updateSelectedProductIndexComment(index);
          //     },
          //     updateSelectedIndex: () {
          //       commentController.clear();
          //       updateSelectedProductIndexComment(index);
          //     },
          //     updateSelectedChildIndex: (childIndex) {
          //       updateSelectedChildIndexComment(
          //         childIndex: childIndex,
          //         productIndex: index,
          //       );
          //     },
          //   );
          // }
        },
      );
    });
  }
}
