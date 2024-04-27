import 'package:flutter/material.dart';

class IconWithNumberQuantity extends StatefulWidget {
  final int productsQuantity;
  final IconData iconData;
  const IconWithNumberQuantity({
    required this.iconData,
    required this.productsQuantity,
    super.key,
  });

  @override
  State<IconWithNumberQuantity> createState() => _IconWithNumberQuantityState();
}

class _IconWithNumberQuantityState extends State<IconWithNumberQuantity> {
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      key: const Key("PrintedProductsIcon"),
      child: Stack(
        children: [
          Icon(
            widget.iconData,
            // Icons.list_outlined,
            color: Colors.grey,
            size: 28,
          ),
          Positioned(
            top: 0,
            right: 0,
            child: CircleAvatar(
              backgroundColor: Colors.red,
              maxRadius: 7,
              child: FittedBox(
                child: Text(
                  widget.productsQuantity.toString(),
                  // presenter.printedProducts == null
                  //     ? "0"
                  //     : presenter.printedProducts!.Products.length.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
