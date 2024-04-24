import 'package:clean_celta_mobile/ui/pages/sale_request_temp/components/request_summary.dart';
import 'package:flutter/material.dart';

import '../../pages.dart';

class ProductsItems extends StatelessWidget {
  final SaleRequestTempViewModel productViewModel;
  const ProductsItems({
    required this.productViewModel,
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
              itemCount: productViewModel.Products.length,
              itemBuilder: (context, index) {
                final cartItem = productViewModel.Products[index];

                return ProductItem(product: cartItem);
              },
            ),
            const RequestSummary(),
          ],
        ),
      ),
    );
  }
}
