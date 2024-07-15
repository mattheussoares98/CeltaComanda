import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class ProductsItems extends StatefulWidget {
  final List<ProductsViewModel> products;
  final ProductsViewModel? selectedProduct;
  const ProductsItems({
    required this.products,
    required this.selectedProduct,
    super.key,
  });

  @override
  State<ProductsItems> createState() => _ProductsItemsState();
}

class _ProductsItemsState extends State<ProductsItems> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount:
          (widget.products.length / (hasMinWidth(context) ? 3 : 2)).ceil(),
      itemBuilder: (context, rowIndex) {
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //essa lógica doida foi o chatGPT que gerou. Usando um gridView não estava dando certo
              for (int i = rowIndex * (hasMinWidth(context) ? 3 : 2);
                  i < (rowIndex + 1) * (hasMinWidth(context) ? 3 : 2);
                  i++)
                if (i < widget.products.length)
                  ProductItem(
                    productsViewModel: widget.products[i],
                    productIsSelected:
                        widget.products[i] == widget.selectedProduct,
                  ),
            ],
          ),
        );
      },
    );
  }
}
