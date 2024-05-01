import 'package:flutter/material.dart';

import '../../pages.dart';

class SaleRequestProductsItems extends StatelessWidget {
  final SaleRequestTempViewModel saleRequestTempViewModel;
  const SaleRequestProductsItems({
    required this.saleRequestTempViewModel,
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
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: saleRequestTempViewModel.Products.length,
              itemBuilder: (context, index) {
                final productViewModel =
                    saleRequestTempViewModel.Products[index];

                return SaleRequestTempProductItem(product: productViewModel);
              },
            ),
            RequestSummary(
              totalLiquid: saleRequestTempViewModel.TotalLiquid,
              comments: saleRequestTempViewModel.Comments,
            ),
          ],
        ),
      ),
    );
  }
}
