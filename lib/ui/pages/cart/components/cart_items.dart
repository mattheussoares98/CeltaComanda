import 'package:flutter/material.dart';

import '../../pages.dart';

class CartItems extends StatelessWidget {
  final List<CartViewModel> cartViewModel;
  const CartItems({
    required this.cartViewModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cartViewModel.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (context, index) {
        final cartItem = cartViewModel[index];

        return CartItem(cartViewModel: cartItem);
      },
    );
  }
}
