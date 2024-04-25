import 'package:flutter/material.dart';

import '../../pages.dart';

class PrintedProduct extends StatelessWidget {
  final PrintedViewModel printed;
  const PrintedProduct({
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
          children: [
            Text("DateHourOfCreation: ${printed.DateHourOfCreation}"),
            Text("Comments: ${printed.Comments}"),
            PrintedProductsItems(
              products: printed.Products,
            ),
            Text("DateOfCreation: ${printed.DateOfCreation}"),
            Text("DeliveryControl: ${printed.DeliveryControl}"),
            Text("EnterpriseId: ${printed.EnterpriseId}"),
            Text("FlagOrigin: ${printed.FlagOrigin}"),
            Text("FlagStatus: ${printed.FlagStatus}"),
            Text("IsCancelled: ${printed.IsCancelled}"),
            Text("IsUsing: ${printed.IsUsing}"),
            Text("Peoples: ${printed.Peoples}"),
            Text("PersonalizedCode: ${printed.PersonalizedCode}"),
            Text("RequestType: ${printed.RequestType}"),
            Text("SaleRequestId: ${printed.SaleRequestId}"),
            Text("TotalLiquid: ${printed.TotalLiquid}"),
          ],
        ),
      ),
    );
  }
}
