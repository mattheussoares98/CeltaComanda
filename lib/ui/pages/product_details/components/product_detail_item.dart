import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:flutter/material.dart';

class ProductDetailItem extends StatelessWidget {
  final ProductDetailsViewModel productDetails;
  const ProductDetailItem(this.productDetails, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(productDetails.name),
      Text(productDetails.price),
      Text(productDetails.image),
    ],);
  }
}
