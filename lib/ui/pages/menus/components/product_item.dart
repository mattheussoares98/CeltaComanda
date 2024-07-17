import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    CommentsPresenter commentsPresenter = Provider.of(context, listen: false);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          menuPresenter.updateSelectedProduct(
            selectedProduct: widget.productsViewModel,
            commentsPresenter: commentsPresenter,
          );

          if (widget.productsViewModel.IsPromoCombox == "true") {
            menuPresenter.goToComboxPage(widget.productsViewModel);
          }
        },
        child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 2, 2, 3),
            child: Container(
              height: (MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height -
                      kBottomNavigationBarHeight - 52) /
                  2,
              width: double.infinity,
              decoration: BoxDecoration(
                color:
                    widget.productIsSelected ? Colors.grey[400] : Colors.white,
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
