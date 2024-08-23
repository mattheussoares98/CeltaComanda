import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class PortraitCartProductItem extends StatefulWidget {
  final CartProductsViewModel cartProduct;
  final int index;
  final double maxWidth;

  const PortraitCartProductItem({
    required this.cartProduct,
    required this.index,
    required this.maxWidth,
    super.key,
  });

  @override
  State<PortraitCartProductItem> createState() =>
      _LandscapeCartProductItemState();
}

class _LandscapeCartProductItemState extends State<PortraitCartProductItem> {
  double rightMargin = 2;

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    InsertProductPresenter insertProductPresenter =
        Provider.of(context, listen: false);
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter =
        Provider.of(context, listen: false);

    return Container(
      margin: EdgeInsets.only(bottom: 5, right: rightMargin),
      padding: EdgeInsets.all(hasMinWidth(context) ? 8 : 3),
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
            children: [
              InkWell(
                onTap: () async {
                  await cartPresenter.removeProductFromCart(widget.index);
                },
                child: SizedBox(
                  width: 20,
                  child: Center(
                    child: Icon(
                      Icons.delete,
                      size: 30,
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
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
                    Text(
                      widget.cartProduct.Product.Name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: getStringSize(context),
                      ),
                    ),
                    if (expansibleGroupFromProductPresenter.productHasComment(
                      product: widget.cartProduct.Product,
                      indexOfChild: 0,
                    ))
                      SizedBox(
                        child:
                            Comment(comment: widget.cartProduct.Comments ?? ""),
                      ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
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
                    selectedProduct: widget.cartProduct.Product,
                  ),
                ),
              ),
              const SizedBox(width: 3),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.35,
                child: PriceAndUpdateProductQuantity(
                  totalLiquid: insertProductPresenter
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
