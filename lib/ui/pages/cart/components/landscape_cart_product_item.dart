import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class LandscapeCartProductItem extends StatefulWidget {
  final CartProductsViewModel cartProduct;
  final int index;
  final double maxWidth;
  final int productIndex;
  final int? selectedIndex;
  final void Function() updateSelectedIndex;
  final TextEditingController controller;
  final void Function() callSetState;
  final FocusNode commentFocusNode;

  const LandscapeCartProductItem({
    required this.cartProduct,
    required this.index,
    required this.maxWidth,
    required this.productIndex,
    required this.selectedIndex,
    required this.updateSelectedIndex,
    required this.controller,
    required this.callSetState,
    required this.commentFocusNode,
    super.key,
  });

  @override
  State<LandscapeCartProductItem> createState() =>
      _LandscapeCartProductItemState();
}

class _LandscapeCartProductItemState extends State<LandscapeCartProductItem> {
  double rightMargin = 2;

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(context, listen: false);

    return Container(
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
              const SizedBox(width: 5),
              SizedBox(
                height: 100,
                width: 150,
                child: GestureDetector(
                  onTap: () {
                    showLargeImage(
                      context: context,
                      ean: widget.cartProduct.Product.EanCode,
                      plu: widget.cartProduct.Product.PriceLookupCode,
                      productComplement:
                          widget.cartProduct.Product.ProductComplement,
                      productName: widget.cartProduct.Product.Name,
                      selectedProduct: widget.cartProduct.Product,
                    );
                  },
                  child: ImageWidget(
                    ean: widget.cartProduct.Product.EanCode,
                    plu: widget.cartProduct.Product.PriceLookupCode,
                    selectedProduct: widget.cartProduct.Product,
                    height: 100,
                    width: 150,
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
                        fontSize: StringSize.size,
                      ),
                    ),
                    if (widget.cartProduct.Comments != null)
                      SizedBox(
                        child: Comment(comment: widget.cartProduct.Comments!),
                      ),
                  ],
                ),
              ),
              PriceAndUpdateProductQuantity(
                product: widget.cartProduct.Product,
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
              ),
            ],
          ),
          ChangeComment(
            productIndex: widget.productIndex,
            showTextFormField: widget.selectedIndex == widget.productIndex,
            updateSelectedIndex: widget.updateSelectedIndex,
            controller: widget.controller,
            callSetState: widget.callSetState,
            focusNode: widget.commentFocusNode,
            childIndex: null,
          ),
          if (widget.cartProduct.Product.childsComposition != null)
            SelectedChilds(
              productIndex: widget.productIndex,
              selectedIndex: widget.selectedIndex,
              updateSelectedIndex: widget.updateSelectedIndex,
              controller: widget.controller,
              callSetState: widget.callSetState,
              focusNode: widget.commentFocusNode,
              cartProduct: widget.cartProduct,
            ),
        ],
      ),
    );
  }
}
