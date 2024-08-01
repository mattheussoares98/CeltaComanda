import 'package:flutter/material.dart';

import '../../pages.dart';

class ProductsItems extends StatefulWidget {
  final List<ProductsViewModel> products;
  final ScrollController scrollController;
  const ProductsItems({
    required this.products,
    required this.scrollController,
    super.key,
  });

  @override
  State<ProductsItems> createState() => _ProductsItemsState();
}

class _ProductsItemsState extends State<ProductsItems> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: widget.scrollController,
      itemCount: widget.products.length,
      itemBuilder: (context, i) {
        return ProductItem(productsViewModel: widget.products[i]);
      },
    );
  }
}
