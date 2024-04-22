import 'package:flutter/material.dart';

import '../../products/products.dart';

class ProductDetailsImage extends StatelessWidget {
  final ProductsViewModel product;
  const ProductDetailsImage({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      product.SaleRetailPraticed,
      fit: BoxFit.cover,
      width: double.infinity,
      height: 300,
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) {
        return Image.asset(
          'lib/ui/assets/images/image_not_found.png',
          width: double.infinity,
          fit: BoxFit.cover,
        );
      },
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Aguarde..."),
              SizedBox(height: 8),
              CircularProgressIndicator(
                color: Colors.grey,
                strokeWidth: 2,
                strokeAlign: -5,
              ),
            ],
          ),
        );
      },
    );
  }
}
