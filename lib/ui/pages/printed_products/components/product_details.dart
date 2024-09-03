import 'package:flutter/material.dart';

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
              child: RequestedAt(printed: printed),
            ),
            Expanded(
              flex: 2,
              child: NameAndComment(product: product, comments: comments),
            ),
            Expanded(
              child: QuantityAndPrice(
                quantity: quantity,
                totalLiquid: totalLiquid,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
