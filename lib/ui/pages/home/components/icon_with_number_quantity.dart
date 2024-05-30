import 'package:flutter/material.dart';

class IconWithNumberQuantity extends StatelessWidget {
  final int productsQuantity;
  final IconData iconData;
  final Color iconColor;
  const IconWithNumberQuantity({
    required this.iconData,
    required this.productsQuantity,
    required this.iconColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      key: const Key("PrintedProductsIcon"),
      child: Stack(
        children: [
          Icon(
            iconData,
            color: iconColor,
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
                  productsQuantity.toString(),
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
