import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages.dart';

class LandscapeInsertProductsPageBody extends StatefulWidget {
  final ProductsViewModel selectedProduct;
  final int indexOfLeftItem;
  final double totalLiquid;
  final AsyncSnapshot<bool> snapshowShowComments;
  const LandscapeInsertProductsPageBody({
    required this.selectedProduct,
    required this.indexOfLeftItem,
    required this.totalLiquid,
    required this.snapshowShowComments,
    super.key,
  });

  @override
  State<LandscapeInsertProductsPageBody> createState() =>
      _LandscapeInsertProductsPageBodyState();
}

class _LandscapeInsertProductsPageBodyState
    extends State<LandscapeInsertProductsPageBody> {
  @override
  Widget build(BuildContext context) {
    CommentsPresenter commentsPresenter = Provider.of(context, listen: false);
    InsertProductPresenter insertProductPresenter =
        Provider.of(context, listen: false);

    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Column(
            children: [
              ImageAndComplement(
                selectedProduct: widget.selectedProduct,
              ),
              LeftItems(
                selectedProduct: widget.selectedProduct,
                indexOfSelectedFather: widget.indexOfLeftItem,
                productHasComment: _getProducthasComment(
                  indexOfLeftItem: widget.indexOfLeftItem,
                  commentsPresenter: commentsPresenter,
                  selectedProduct: widget.selectedProduct,
                ),
              ),
              Divider(
                color: Theme.of(context).primaryColorLight,
                thickness: 0.1,
                height: 1,
              ),
              TotalPriceCombox(
                totalLiquid: widget.totalLiquid,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              if (widget.selectedProduct.childsComposition != null &&
                  widget.indexOfLeftItem <
                      widget.selectedProduct.childsComposition!.length)
                Text(
                  widget.selectedProduct
                      .childsComposition![widget.indexOfLeftItem].ChildName!,
                  style: TextStyle(
                    fontSize: getStringSize(context) * 1.4,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
              Expanded(
                child: TitleText(
                  selectedLeftIndex: widget.indexOfLeftItem,
                  selectedProduct: widget.selectedProduct,
                  showComments: _getShowComments(
                    snapshowShowComments: widget.snapshowShowComments,
                    product: widget.selectedProduct,
                    indexOfLeftItem: widget.indexOfLeftItem,
                  ),
                  productHasComment: _getProducthasComment(
                    indexOfLeftItem: widget.indexOfLeftItem,
                    commentsPresenter: commentsPresenter,
                    selectedProduct: widget.selectedProduct,
                  ),
                ),
              ),
              AdvanceButton(
                totalPrice: widget.totalLiquid,
                quantity: insertProductPresenter.totalProductsQuantity,
                advanceSelectedIndex: () {
                  insertProductPresenter.advanceLeftIndex(commentsPresenter);
                },
                selectedProduct: widget.selectedProduct,
                leftSelectedIndex: widget.indexOfLeftItem,
                productHasComment: _getProducthasComment(
                  indexOfLeftItem: widget.indexOfLeftItem,
                  commentsPresenter: commentsPresenter,
                  selectedProduct: widget.selectedProduct,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

bool _getProducthasComment({
  required int indexOfLeftItem,
  required CommentsPresenter commentsPresenter,
  required ProductsViewModel selectedProduct,
}) {
  if (selectedProduct.childsComposition == null) {
    return commentsPresenter.productHasComment(
      internalCodeOnERP: selectedProduct.InternalCodeOnERP!.toInt(),
      productName: selectedProduct.Name,
    );
  } else if (indexOfLeftItem == selectedProduct.childsComposition!.length) {
    return false;
  } else {
    return commentsPresenter.productHasComment(
      internalCodeOnERP: selectedProduct
          .childsComposition![indexOfLeftItem].InternalCodeOnERPCodeChild!
          .toInt(),
      productName:
          selectedProduct.childsComposition![indexOfLeftItem].ChildName!,
    );
  }
}

bool _getShowComments({
  required AsyncSnapshot<bool> snapshowShowComments,
  required ProductsViewModel product,
  required int indexOfLeftItem,
}) {
  if (product.childsComposition == null && indexOfLeftItem == 0) {
    return true;
  } else if (product.childsComposition == null && indexOfLeftItem == 1) {
    return false;
  } else {
    return snapshowShowComments.data ?? false;
  }
}
