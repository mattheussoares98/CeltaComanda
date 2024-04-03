import 'package:flutter/material.dart';

import '../../expansible_groups/expansible_groups.dart';

class CartIcon extends StatelessWidget {
  final ExpansibleGroupsPresenter presenter;
  const CartIcon({
    required this.presenter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: presenter.goToCartPage,
      icon: const Icon(
        Icons.shopping_cart_rounded,
        color: Colors.red,
        shadows: [
          Shadow(
            offset: Offset(1, 1),
            blurRadius: 2.0,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
