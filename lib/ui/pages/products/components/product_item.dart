import 'package:clean_celta_mobile/ui/pages/products/components/image_widget.dart';
import 'package:clean_celta_mobile/ui/pages/products/products.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final ProductsViewModel product;
  const ProductItem({
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<ProductsPresenter>(context);

    return GestureDetector(
      onTap: presenter.goToProductDetailsPage,
      child: Card(
        margin: const EdgeInsets.all(8),
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageWidget(product: product),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    product.price.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
