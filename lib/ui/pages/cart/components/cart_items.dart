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
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: productViewModel.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (context, index) {
        final cartItem = productViewModel[index];

        return CartItem(productViewModel: cartItem);
      },
    );
  }
}
