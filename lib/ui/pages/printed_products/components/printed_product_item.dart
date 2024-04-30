import 'package:flutter/material.dart';

import '../../pages.dart';

class PrintedProductItem extends StatelessWidget {
  final ProductsViewModel product;
  final String quantity;
  final String totalLiquid;
  final String? comments;
  final String saleRequestProductId;
  const PrintedProductItem({
    required this.product,
    required this.quantity,
    required this.totalLiquid,
    required this.comments,
    required this.saleRequestProductId,
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
          saleRequestProductId: saleRequestProductId,
        ),
      ],
    );
  }
}
