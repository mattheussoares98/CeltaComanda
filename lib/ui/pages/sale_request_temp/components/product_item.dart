import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../pages.dart';

class ProductItem extends StatelessWidget {
  final ProductsViewModel product;
  final String? comments;
  final String totalLiquid;
  final String quantity;
  const ProductItem({
    required this.product,
    required this.comments,
    required this.totalLiquid,
    required this.quantity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ImageWidget(product: product),
        ProductDetails(
          nameComplete: product.NameComplete,
          name: product.Name,
          eanCode: product.EanCode,
          plu: product.PriceLookupCode,
          comments: comments,
          saleRetailPraticed: product.SaleRetailPraticed,
          totalLiquid: totalLiquid,
          quantity: quantity,
          onPressedAddQuantity: () {},
          onPressedReduceQuantity: () {},
          isPrintedProducts: false,
        ),
      ],
    );
  }
}
