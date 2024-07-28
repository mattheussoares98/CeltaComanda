import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/adapters/adapters.dart';
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
  InsertProductAdapter getInsertProductAdapter(
    InsertProductPresenter insertProductsPresenter,
    CommentsPresenter commentsPresenter,
  ) {
    return InsertProductAdapter(
        advanceSelectedIndex: () {
          insertProductsPresenter.advanceLeftIndex(commentsPresenter);
        },
        totalProductsQuantity: insertProductsPresenter.totalProductsQuantity,
        updateTotalLiquid: () {
          insertProductsPresenter
              .updateTotalLiquid(widget.productsViewModel);
        },
        totalPriceStream: insertProductsPresenter.totalPrice,
        doScrollStream: insertProductsPresenter.doScrollStream,
        showCommentsStream: insertProductsPresenter.showCommentsStream,
        selectedProduct: widget.productsViewModel,
        isLoadingStream: insertProductsPresenter.isLoadingStream,
        mainErrorStream: insertProductsPresenter.mainErrorStream,
        selectedComboxProductStream:
            insertProductsPresenter.selectedProductStream,
        selectedItemIndexStream:
            insertProductsPresenter.selectedLeftIndexStream,
        updateSelectedProduct: () {
          insertProductsPresenter
              .updateSelectedProduct(widget.productsViewModel);
        },
        doOnClosePage: () {
          insertProductsPresenter.clearData(
            product: widget.productsViewModel,
            commentsPresenter: commentsPresenter,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    CommentsPresenter commentsPresenter = Provider.of(context, listen: false);
    InsertProductPresenter insertProductsPresenter =
        Provider.of(context, listen: false);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          menuPresenter.goToInsertProductPage(
            getInsertProductAdapter(
              insertProductsPresenter,
              commentsPresenter,
            ),
          );
          insertProductsPresenter
              .updateSelectedProduct(widget.productsViewModel);
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
