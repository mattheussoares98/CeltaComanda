import 'package:flutter/material.dart';

import '../../pages.dart';

class ProductItem extends StatelessWidget {
  final SaleRequestTempProductsViewModel product;

  const ProductItem({
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductDetails(
          isPrintedProducts: false,
          Product: product.Product,
          onPressedAddQuantity: () {},
          onPressedReduceQuantity: () {},
          onPressedRemoveProduct: null,
          quantity: product.Quantity,
          value: product.Value,
          totalLiquid: product.TotalLiquid,
          comments: product.Comments,
        ),
        // if (product.Comments != null) Text("Comments: ${product.Comments}"),
        // Text("SaleRequestProductTempId ${product.SaleRequestProductTempId}"),
        // Text("IsPrinted ${product.IsPrinted}"),

        // Text("SaleRequestTempId ${product.SaleRequestTempId}"),
        // Text("ProductInternalCodeOnErp ${product.ProductInternalCodeOnErp}"),
        // Text("TotalLiquid ${product.TotalLiquid}"),
        // Text("Quantity ${product.Quantity}"),
        // Text("Value ${product.Value}"),
        // Text("PLU ${product.ProductPriceLookUpCode}"),
      ],
    );
  }
}
