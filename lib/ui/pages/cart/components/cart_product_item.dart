import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class CartProductItem extends StatefulWidget {
  final CartProductsViewModel cartProduct;
  final int index;

  const CartProductItem({
    required this.cartProduct,
    required this.index,
    super.key,
  });

  @override
  State<CartProductItem> createState() =>
      _CartProductItemState();
}

class _CartProductItemState
    extends State<CartProductItem> {
  void onPressedAddQuantity({
    required CartPresenter cartPresenter,
  }) {
    cartPresenter.addCartProductQuantity(widget.index);
  }

  void onPressedReduceQuantity({
    required CartPresenter cartPresenter,
  }) {
    if (widget.cartProduct.Quantity.toDouble() <= 1) {
      notificationDialog(
        context: context,
        titleMessage: "Remover produto do carrinho?",
        content: null,
        onPress: () async {
          cartPresenter.reduceCartProductQuantity(widget.index);
        },
      );
    } else {
      cartPresenter.reduceCartProductQuantity(widget.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageWidget(
              ean: widget.cartProduct.Product.EanCode,
              plu: widget.cartProduct.Product.PriceLookupCode,
              showLargeImageInShowDialog: true,
            ),
            const SizedBox(width: 3),
            Expanded(
              child: Text(
                widget.cartProduct.Product.Name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            PriceAndUpdateProductQuantity(
              showDeleteIcon: widget.cartProduct.Quantity.toDouble() <= 1,
              showUpdateProductQuantity: true,
              price: widget.cartProduct.Value.toDouble(),
              totalLiquid: widget.cartProduct.Quantity.toDouble() *
                  widget.cartProduct.Value.toDouble(),
              onPressedReduceQuantity: () {
                onPressedReduceQuantity(
                  cartPresenter: cartPresenter,
                );
              },
              onPressedAddQuantity: () {
                onPressedAddQuantity(
                  cartPresenter: cartPresenter,
                );
              },
              productQuantity: widget.cartProduct.Quantity.toDouble(),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Comment(
          index: widget.index,
          comments: widget.cartProduct.Comments,
        ),
        const Divider(
          thickness: 0.2,
        )
      ],
    );
  }
}
