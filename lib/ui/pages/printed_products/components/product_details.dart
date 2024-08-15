import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../ui/components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class ProductDetails extends StatelessWidget {
  final ProductsViewModel product;
  final void Function()? onPressedRemoveProduct;
  final void Function()? validateUserAndCancelProducts;
  final String quantity;
  final String value;
  final String totalLiquid;
  final String? comments;

  const ProductDetails({
    required this.product,
    required this.onPressedRemoveProduct,
    required this.quantity,
    required this.value,
    required this.totalLiquid,
    required this.validateUserAndCancelProducts,
    required this.comments,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  showLargeImage(
                    context: context,
                    ean: product.EanCode,
                    productComplement: product.ProductComplement,
                    plu: product.PriceLookupCode,
                    menuPresenter: menuPresenter,
                    productName: product.Name,
                    selectedProduct: product,
                  );
                },
                child: ImageWidget(
                  ean: product.EanCode,
                  plu: product.PriceLookupCode,
                  isAlcoholic: product.IsAlcoholicProduct.toString() == "true",
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                product.Name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: getStringSize(context),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "$quantity ",
                          style: TextStyle(
                            fontSize: getStringSize(context) * 0.8,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        // InkWell(
                        //   onTap: printedProductsPresenter.canCancelProducts
                        //       ? onPressedRemoveProduct
                        //       : validateUserAndCancelProducts,
                        //   child: Icon(
                        //     Icons.delete,
                        //     color: printedProductsPresenter.canCancelProducts
                        //         ? Colors.red
                        //         : Colors.grey,
                        //     size: 30,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      totalLiquid.addBrazilianCoin(),
                      style: TextStyle(
                        fontSize: getStringSize(context) * 0.8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (comments != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Comment(comment: comments!),
          ),
      ],
    );
  }
}
