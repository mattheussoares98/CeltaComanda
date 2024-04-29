import 'package:flutter/material.dart';

import '../../pages.dart';

class ProductsItems extends StatelessWidget {
  final SaleRequestTempViewModel saleRequestTempProductViewModel;
  const ProductsItems({
    required this.saleRequestTempProductViewModel,
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
              itemCount: saleRequestTempProductViewModel.Products.length,
              itemBuilder: (context, index) {
                final cartItem = saleRequestTempProductViewModel.Products[index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ProductItem(
                      product: cartItem,
                      saleRequestTempViewModel: saleRequestTempProductViewModel,
                    ),
                  ],
                );
              },
            ),
            const RequestSummary(),
          ],
        ),
      ),
    );
  }
}
