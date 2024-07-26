import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';

class ProductItem extends StatefulWidget {
  final ProductsViewModel productsViewModel;

  const ProductItem({
    required this.productsViewModel,
    super.key,
  });

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    ProductCompositionPresenter productCompositionPresenter =
        Provider.of(context, listen: false);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          menuPresenter.goToInsertProductPage(widget.productsViewModel);
          if (widget.productsViewModel.childsComposition != null) {
            productCompositionPresenter
                .updateSelectedProduct(widget.productsViewModel);
          }
        },
        child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 2, 2, 3),
            child: Container(
              height: (MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height) /
                  2.5,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
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
              child: NameImagePriceComboxAndComplement(
                productsViewModel: widget.productsViewModel,
              ),
            )),
      ),
    );
  }
}
