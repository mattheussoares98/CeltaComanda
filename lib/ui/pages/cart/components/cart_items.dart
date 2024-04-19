import 'package:clean_celta_mobile/ui/pages/cart/components/request_summary.dart';
import 'package:flutter/material.dart';

import '../../pages.dart';

class CartItems extends StatelessWidget {
  final List<ProductsViewModel> productViewModel;
  const CartItems({
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
              itemCount: productViewModel.length,
              itemBuilder: (context, index) {
                final cartItem = productViewModel[index];

                return CartItem(product: cartItem);
              },
            ),
            const RequestSummary(),
          ],
        ),
      ),
    );
  }
}
