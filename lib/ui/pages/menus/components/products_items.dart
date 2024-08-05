import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';

class ProductsItems extends StatefulWidget {
  final List<ProductsViewModel> products;
  final ScrollController scrollController;
  final int? selectedGroupIndex;
  const ProductsItems({
    required this.products,
    required this.scrollController,
    required this.selectedGroupIndex,
    super.key,
  });

  @override
  State<ProductsItems> createState() => _ProductsItemsState();
}

class _ProductsItemsState extends State<ProductsItems> {
  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);

    if (widget.selectedGroupIndex! + 1 == menuPresenter.loadedMenu.length) {
      return const EvaluateService();
    }
    return ListView.builder(
      controller: widget.scrollController,
      itemCount: widget.products.length,
      itemBuilder: (context, i) {
        return ProductItem(productsViewModel: widget.products[i]);
      },
    );
  }
}
