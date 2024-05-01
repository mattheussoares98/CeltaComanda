import 'package:flutter/material.dart';

import '../../../../ui/pages/products/products.dart';

class ProductsItems extends StatelessWidget {
  final List<ProductsViewModel> products;
  const ProductsItems({
    required this.products,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final productViewModel = products[index];

          return ProductItem(
            product: productViewModel,
            indexOfProduct: index,
          );
        },
      ),
    );
  }
}
