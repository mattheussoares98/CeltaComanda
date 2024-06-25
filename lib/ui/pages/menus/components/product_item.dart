import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
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
        onLongPress: () {
          ImageWidget.showLargeImage(
            context: context,
            ean: widget.productsViewModel.EanCode,
            plu: widget.productsViewModel.PriceLookupCode,
          );
        },
        onTap: () {
          menuPresenter.updateSelectedProduct(widget.productsViewModel);
          commentsPresenter.unselectAllComments();

          if (widget.productsViewModel.IsPromoCombox == "true") {
            menuPresenter.goToComboxPage(widget.productsViewModel);
          }
        },
        child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 2, 2, 3),
            child: Container(
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
              child: NameImagePriceAndCombox(
                  productsViewModel: widget.productsViewModel),
            )),
      ),
    );
  }
}
