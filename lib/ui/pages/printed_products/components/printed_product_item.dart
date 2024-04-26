import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../pages.dart';

class PrintedProductItem extends StatelessWidget {
  final PrintedProductViewModel product;
  final String quantity;
  const PrintedProductItem({
    required this.product,
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
        ),

        UpdateProductQuantity(
          quantity: quantity,
          onPressedAddQuantity: () {},
          onPressedReduceQuantity: () {},
        ),
      ],
    );
  }
}
