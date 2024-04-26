import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../pages.dart';

class ProductItem extends StatelessWidget {
  final ProductsViewModel product;
  const ProductItem({
    required this.product,
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
        ),
        UpdateProductQuantity(
          quantity: "xxx",
          onPressedAddQuantity: () {},
          onPressedReduceQuantity: () {},
        ),
      ],
    );
  }
}
