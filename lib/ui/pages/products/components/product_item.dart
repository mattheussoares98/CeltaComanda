import 'package:clean_celta_mobile/ui/pages/products/products.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'dart:math';

class ProductItem extends StatelessWidget {
  final ProductsViewModel product;
  const ProductItem({
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final color = Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );

    final presenter = Provider.of<ProductsPresenter>(context);

    return GestureDetector(
      onTap: presenter.goToProductDetailsPage,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                product.image,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
            Text(
              product.price.toString(),
              style: const TextStyle(
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 3,
                    offset: Offset(2, 2),
                  ),
                ],
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              product.name.toString(),
              style: const TextStyle(
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 3,
                    offset: Offset(2, 2),
                  ),
                ],
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
