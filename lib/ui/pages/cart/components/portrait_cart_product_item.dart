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
  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    MenuPresenter menuPresenter = Provider.of(context, listen: false);

    return Container(
      margin: const EdgeInsets.only(bottom: 5, right: 2, left: 2),
      padding: const EdgeInsets.all(3),
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
                child: Center(
                  child: Icon(
                    Icons.delete,
                    size: 30,
                    color: Theme.of(context).primaryColorLight,
                  ),
                ),
              ),
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
                    Comment(comment: widget.cartProduct.Comments),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 3),
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
                      width: MediaQuery.of(context).size.width * 0.4,
                      selectedProduct: widget.cartProduct.Product,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 3),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.35,
                child: PriceAndUpdateProductQuantity(
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
