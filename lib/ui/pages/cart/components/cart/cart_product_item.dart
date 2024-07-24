import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../../components/components.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class CartProductItem extends StatefulWidget {
  final CartProductsViewModel cartProduct;
  final int index;
  final double maxWidth;

  const CartProductItem({
    required this.cartProduct,
    required this.index,
    required this.maxWidth,
    super.key,
  });

  @override
  State<CartProductItem> createState() => _CartProductItemState();
}

class _CartProductItemState extends State<CartProductItem> {
  double rightMargin = 2;

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    CommentsPresenter commentsPresenter = Provider.of(context, listen: false);

    return Container(
      width: widget.maxWidth * 0.3333333 - rightMargin,
      margin: EdgeInsets.only(bottom: 5, right: rightMargin),
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
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  await cartPresenter.removeProductFromCart(widget.index);
                },
                child: SizedBox(
                  height: 100,
                  width: 40,
                  child: Center(
                    child: Icon(
                      Icons.delete,
                      size: 30,
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 30),
              SizedBox(
                height: 100,
                width: 100,
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
                    height: 100,
                    width: 100,
                    isAlcoholic: widget.cartProduct.Product.IsAlcoholicProduct
                            .toString() ==
                        "true",
                  ),
                ),
              ),
              const SizedBox(width: 3),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      widget.cartProduct.Product.Name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: getStringSize(context),
                      ),
                    ),
                    if (commentsPresenter.productHasComment(
                      internalCodeOnERP:
                          widget.cartProduct.Product.InternalCodeOnERP!.toInt(),
                      productName: widget.cartProduct.Product.Name,
                    ))
                      SizedBox(
                        child: CommentRichText(
                            comment: widget.cartProduct.Comments!),
                      ),
                  ],
                ),
              ),
              PriceAndUpdateProductQuantity(
                showItemPrice: false,
                showUpdateProductQuantity: true,
                price: widget.cartProduct.Value.toDouble(),
                totalLiquid: widget.cartProduct.Quantity.toDouble() *
                    widget.cartProduct.Value.toDouble(),
                onPressedReduceQuantity:
                    widget.cartProduct.Quantity.toDouble() <= 1
                        ? null
                        : () async {
                            await cartPresenter
                                .reduceCartProductQuantity(widget.index);
                          },
                onPressedAddQuantity: () async {
                  await cartPresenter.addCartProductQuantity(widget.index);
                },
                productQuantity: widget.cartProduct.Quantity.toDouble(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
