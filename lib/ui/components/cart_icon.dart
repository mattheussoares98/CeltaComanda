import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../presentation/presenters/presenters.dart';

class CartIcon extends StatefulWidget {
  const CartIcon({
    super.key,
  });

  @override
  State<CartIcon> createState() => _CartIconState();
}

class _CartIconState extends State<CartIcon> {
  @override
  Widget build(BuildContext context) {
    GetxExpansibleGroupsPresenter presenter = Provider.of(context);

    return GestureDetector(
      key: const Key("CartIcon"),
      onTap: presenter.goToCartPage,
      child: FittedBox(
        child: Stack(
          children: [
            IconButton(
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.grey,
                size: 28,
              ),
              onPressed: presenter.goToCartPage,
            ),
            Positioned(
              top: 2,
              right: 2,
              child: CircleAvatar(
                backgroundColor: Colors.red,
                maxRadius: 9,
                child: FittedBox(
                  child: Text(
                    presenter.saleRequestTemp?.Products.length.toString() ??
                        "0",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
