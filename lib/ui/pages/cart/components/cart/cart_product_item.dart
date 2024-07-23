import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../../components/components.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

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
    CommentsPresenter commentsPresenter = Provider.of(context, listen: false);
    MenuPresenter menuPresenter = Provider.of(context, listen: false);

    return Flexible(
      child: Container(
        width:
            (MediaQuery.of(context).size.width / (getItensPerLine(context))),
        margin: const EdgeInsets.only(bottom: 2, right: 2),
        padding: const EdgeInsets.fromLTRB(2, 2, 3, 0),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 70,
                  width: 70,
                  child: GestureDetector(
                    onTap: () {
                      showLargeImage(
                        context: context,
                        ean: widget.cartProduct.Product.EanCode,
                        plu: widget.cartProduct.Product.PriceLookupCode,
                        productComplement:
                            widget.cartProduct.Product.ProductComplement,
                        menuPresenter: menuPresenter,
                        productName: widget.cartProduct.Product.Name,
                        selectedProduct: widget.cartProduct.Product,
                      );
                    },
                    child: ImageWidget(
                      ean: widget.cartProduct.Product.EanCode,
                      plu: widget.cartProduct.Product.PriceLookupCode,
                      height: 70,
                      width: 70,
                      isAlcoholic: widget.cartProduct.Product.IsAlcoholicProduct
                              .toString() ==
                          "true",
                    ),
                  ),
                ),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    widget.cartProduct.Product.Name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: getStringSize(context),
                    ),
                  ),
                ),
                PriceAndUpdateProductQuantity(
                  showItemPrice: false,
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
            if (commentsPresenter.productHasComment(
              internalCodeOnERP:
                  widget.cartProduct.Product.InternalCodeOnERP!.toInt(),
              productName: widget.cartProduct.Product.Name,
            ))
              Comment(
                comments: widget.cartProduct.Comments,
                productName: widget.cartProduct.Product.Name,
                internalCodeOnErp:
                    widget.cartProduct.Product.InternalCodeOnERP!.toInt(),
                updateComment: () async {
                  await cartPresenter.updateCommentOfProductCart(
                    index: widget.index,
                    newComment:
                        commentsPresenter.getConcatenateSelectedComments(),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
