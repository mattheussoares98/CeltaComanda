import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class LandscapeCartProductItem extends StatefulWidget {
  final CartProductsViewModel cartProduct;
  final int index;
  final double maxWidth;

  const LandscapeCartProductItem({
    required this.cartProduct,
    required this.index,
    required this.maxWidth,
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
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter =
        Provider.of(context, listen: false);

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
                    if (widget.cartProduct.Product.childsComposition != null)
                      FittedBox(
                        child: Text(
                          "(${R.string.combox})",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: getStringSize(context),
                          ),
                        ),
                      ),
                    if (expansibleGroupFromProductPresenter.productHasComment(
                      product: widget.cartProduct.Product,
                      indexOfChild: -1,
                    ))
                      SizedBox(
                        child:
                            Comment(comment: widget.cartProduct.Comments ?? ""),
                      ),
                  ],
                ),
              ),
              PriceAndUpdateProductQuantity(
                showItemPrice: false,
                showUpdateProductQuantity: true,
                price: cartPresenter
                    .calculateProductPrice(widget.cartProduct.Product),
                totalLiquid: widget.cartProduct.Quantity.toDouble() *
                    cartPresenter
                        .calculateProductPrice(widget.cartProduct.Product),
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
                productQuantity: widget.cartProduct.Quantity.toInt(),
              ),
            ],
          ),
          if (widget.cartProduct.Product.childsComposition != null)
            SelectedChilds(cartProduct: widget.cartProduct),
        ],
      ),
    );
  }
}
