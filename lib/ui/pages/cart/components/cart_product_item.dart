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
  State<CartProductItem> createState() => _CartProductItemState();
}

class _CartProductItemState extends State<CartProductItem> {
  TextEditingController commentsController = TextEditingController();

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
  void dispose() {
    super.dispose();
    commentsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(context, listen: false);

    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color.fromARGB(255, 220, 218, 218)),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            color: Color(0x33000000),
            offset: Offset(-3, -1),
          )
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
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
            indexOfProduct: widget.index,
            comments: widget.cartProduct.Comments,
            clearComment: () async {
              await cartPresenter.updateCommentOfProductCart(
                index: widget.index,
                newComment: null,
              );
            },
            updateSelectedIndex: () {
              cartPresenter.updateIndexOfSelectedCartProduct(widget.index);
            },
            indexOfSelectedProduct: cartPresenter.indexOfSelectedProduct,
            commentsController: commentsController,
            updateComment: () async {
              await cartPresenter.updateCommentOfProductCart(
                index: widget.index,
                newComment: commentsController.text,
              );
            },
          ),
        ],
      ),
    );
  }
}
