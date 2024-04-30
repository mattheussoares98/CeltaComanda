import 'package:flutter/material.dart';

import '../../pages.dart';

class PrintedItem extends StatelessWidget {
  final PrintedViewModel printed;
  const PrintedItem({
    required this.printed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
              blurRadius: 4, color: Color(0x33000000), offset: Offset(0, 2))
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: printed.Products.length,
              itemBuilder: (context, index) {
                final product = printed.Products[index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        // ImageWidget(product: product),
                        ProductDetails(
                          nameComplete: product.Products.NameComplete,
                          name: product.Products.Name,
                          eanCode: product.Products.EanCode,
                          plu: product.Products.PriceLookupCode,
                          saleRetailPraticed:
                              product.Products.SaleRetailPraticed,
                          comments: product.Comments,
                          totalLiquid: product.TotalLiquid,
                          quantity: product.Quantity,
                          saleRequestProductId: product.SaleRequestProductId,
                        ),
                      ],
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 0.4,
                    ),
                    // Text("DateHourOfCreation ${product.DateHourOfCreation}"),
                    // Text(
                    //     "SaleRequestProductId ${product.SaleRequestProductId}"),
                    // Text("Quantity ${product.Quantity}"),
                    // Text("UserId ${product.UserId}"),
                    // Text("IsCancelled ${product.IsCancelled}"),
                    // Text("IsDelivered ${product.IsDelivered}"),
                    // Text("IsPrinted ${product.IsPrinted}"),
                    // Text("ProductionStatus ${product.ProductionStatus}"),
                    // Text(
                    //     "ProductInternalCodeOnErp ${product.ProductInternalCodeOnErp}"),
                    // Text("SaleRequestId ${product.SaleRequestId}"),
                  ],
                );
              },
            ),
            RequestSummary(totalLiquid: printed.TotalLiquid),
            Text("Comentário: ${printed.Comments}"),
            // Text("Comanda: ${printed.PersonalizedCode}"),
            // Text("DateHourOfCreation: ${printed.DateHourOfCreation}"),
            // Text("DateOfCreation: ${printed.DateOfCreation}"),
            // Text("DeliveryControl: ${printed.DeliveryControl}"),
            // Text("EnterpriseId: ${printed.EnterpriseId}"),
            // Text("FlagOrigin: ${printed.FlagOrigin}"),
            // Text("FlagStatus: ${printed.FlagStatus}"),
            // Text("IsCancelled: ${printed.IsCancelled}"),
            // Text("IsUsing: ${printed.IsUsing}"),
            // Text("Peoples: ${printed.Peoples}"),
            // Text("RequestType: ${printed.RequestType}"),
            // Text("SaleRequestId: ${printed.SaleRequestId}"),
          ],
        ),
      ),
    );
  }
}
