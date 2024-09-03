import 'package:flutter/material.dart';

import '../../../../ui/components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class ProductDetails extends StatelessWidget {
  final ProductsViewModel product;
  final PrintedViewModel printed;
  final void Function()? onPressedRemoveProduct;
  final void Function()? validateUserAndCancelProducts;
  final String quantity;
  final String value;
  final String totalLiquid;
  final String? comments;

  const ProductDetails({
    required this.product,
    required this.printed,
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
    return Column(
      children: [
        Row(
          children: [
            // Expanded(
            //   child: GestureDetector(
            //     onTap: () {
            //       showLargeImage(
            //         context: context,
            //         ean: product.EanCode,
            //         productComplement: product.ProductComplement,
            //         plu: product.PriceLookupCode,
            //         menuPresenter: menuPresenter,
            //         productName: product.Name,
            //         selectedProduct: product,
            //       );
            //     },
            //     child: ImageWidget(
            //       ean: product.EanCode,
            //       plu: product.PriceLookupCode,
            //       selectedProduct: product,
            //     ),
            //   ),
            // ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(hasMinWidth(context) ? 5 : 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      child: Text(
                        R.string.requestedAt,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: getStringSize(context) * 0.8,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    FittedBox(
                      child: Text(
                        "${DateTime.parse(printed.DateHourOfCreation).hour}:${DateTime.parse(printed.DateHourOfCreation).minute}:${DateTime.parse(printed.DateHourOfCreation).second}",
                        style: TextStyle(
                          fontSize: getStringSize(context) * 0.8,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text(
                    product.Name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: getStringSize(context),
                    ),
                  ),
                  if (comments != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Comment(comment: "($comments)"),
                    ),
                ],
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
                          "${R.string.quantityAbbreviated} $quantity ",
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
      ],
    );
  }
}
