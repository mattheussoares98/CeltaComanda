import 'package:flutter/material.dart';

import '../../../../ui/pages/products/components/product_item.dart';
import '../../../../ui/pages/products/products.dart';

class ProductsItems extends StatelessWidget {
  final List<ProductsViewModel> productsViewModel;
  const ProductsItems({
    required this.productsViewModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: productsViewModel.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (context, index) {
        final groupViewModel = productsViewModel[index];

        return ProductItem(product: groupViewModel);
      },
    );
  }
}
