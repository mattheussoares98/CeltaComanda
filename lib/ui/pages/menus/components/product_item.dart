import 'package:flutter/material.dart';

import '../../pages.dart';

class ProductItem extends StatefulWidget {
  final ProductsViewModel productsViewModel;

  final bool productIsSelected;

  const ProductItem({
    required this.productsViewModel,
    required this.productIsSelected,
    super.key,
  });

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: widget.productIsSelected
            ? Theme.of(context).primaryColorLight
            : Colors.white,
        boxShadow: const [
          BoxShadow(
            blurRadius: 3,
            color: Color(0x411D2429),
            offset: Offset(
              2,
              -2,
            ),
          ),
          BoxShadow(
            blurRadius: 3,
            color: Color(0x411D2429),
            offset: Offset(
              -2,
              2,
            ),
          )
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
        child: NameImagePriceAndCombox(productsViewModel: widget.productsViewModel),
      ),
    );
  }
}
