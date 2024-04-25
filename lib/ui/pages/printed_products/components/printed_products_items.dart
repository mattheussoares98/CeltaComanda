import 'package:flutter/material.dart';

import '../../pages.dart';

class PrintedProductsItems extends StatelessWidget {
  final List<PrintedProductsViewModel> products;
  const PrintedProductsItems({
    required this.products,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];

            return Column(
              children: [
                PrintedProductItem(
                  product: product.Products,
                ),
                Text("PLU ${product.ProductPriceLookUpCode}"),
                Text("QuantityString ${product.QuantityString}"),
                Text("Comments ${product.Comments}"),
                Text("DateHourOfCreation ${product.DateHourOfCreation}"),
                Text("SaleRequestProductId ${product.SaleRequestProductId}"),
                Text("Value ${product.Value}"),
                Text("Quantity ${product.Quantity}"),
                Text("UserId ${product.UserId}"),
                Text("IsCancelled ${product.IsCancelled}"),
                Text("IsDelivered ${product.IsDelivered}"),
                Text("IsPrinted ${product.IsPrinted}"),
                Text("ProductionStatus ${product.ProductionStatus}"),
                Text("TotalLiquid ${product.TotalLiquid}"),
                Text(
                    "ProductInternalCodeOnErp ${product.ProductInternalCodeOnErp}"),
                Text("SaleRequestId ${product.SaleRequestId}"),
              ],
            );
          },
        ),
      ],
    );
  }
}
