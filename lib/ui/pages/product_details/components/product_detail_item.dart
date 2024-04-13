import '../../../../ui/pages/pages.dart';
import 'package:flutter/material.dart';

class ProductDetailItem extends StatelessWidget {
  final ProductsViewModel product;
  const ProductDetailItem(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProductDetailsImage(product: product),
        Text(product.name),
        Text(product.price),
      ],
    );
  }
}
