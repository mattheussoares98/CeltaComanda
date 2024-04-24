import 'package:clean_celta_mobile/presentation/presenters/getx_expansible_groups_presenter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartIcon extends StatefulWidget {
  final void Function()? goToCartPage;
  final Color? color;
  const CartIcon({
    this.color = Colors.grey,
    required this.goToCartPage,
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
      onTap: widget.goToCartPage,
      child: FittedBox(
        child: Stack(
          children: [
            IconButton(
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: widget.color,
                size: 28,
              ),
              onPressed: widget.goToCartPage,
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
