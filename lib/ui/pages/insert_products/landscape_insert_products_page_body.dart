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
  bool showComments = false;
  bool productHasComment = false;

  @override
  Widget build(BuildContext context) {
    CommentsPresenter commentsPresenter = Provider.of(context, listen: false);
    InsertProductPresenter insertProductPresenter =
        Provider.of(context, listen: false);
    showComments = _getShowComments(
      snapshowShowComments: widget.snapshowShowComments,
      product: widget.selectedProduct,
      indexOfLeftItem: widget.indexOfLeftItem,
    );
    productHasComment = _getProducthasComment(
      indexOfLeftItem: widget.indexOfLeftItem,
      commentsPresenter: commentsPresenter,
      selectedProduct: widget.selectedProduct,
    );

    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Column(
            children: [
              ImageAndComplement(
                selectedProduct: widget.selectedProduct,
              ),
              Expanded(
                child: FathersItems(
                  selectedProduct: widget.selectedProduct,
                  indexOfSelectedFather: widget.indexOfLeftItem,
                  productHasComment: productHasComment,
                  showComments: showComments,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: TotalPriceCombox(
                  totalLiquid: widget.totalLiquid,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Column(
              children: [
                if (widget.selectedProduct.childsComposition != null &&
                    widget.indexOfLeftItem <
                        widget.selectedProduct.childsComposition!.length)
                  Text(
                    _selectedFather(
                            widget.selectedProduct, widget.indexOfLeftItem)
                        .ChildName!,
                    style: TextStyle(
                      fontSize: getStringSize(context) * 1.4,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                if (hasMinWidth(context))
                  TitleText(
                    indexOfLeftItem: widget.indexOfLeftItem,
                    selectedProduct: widget.selectedProduct,
                    showComments: showComments,
                    productHasComment: productHasComment,
                  ),
                if (showComments)
                  Expanded(
                    child: CommentsList(
                      selectedProduct: widget.selectedProduct,
                      selectedLeftIndex: widget.indexOfLeftItem,
                    ),
                  ),
                if (_showUpdateQuantity(
                  selectedProduct: widget.selectedProduct,
                  indexOfSelectedFather: widget.indexOfLeftItem,
                  productHasComment: productHasComment,
                ))
                  const Expanded(child: UpdateQuantity()),
                if (!showComments &&
                    widget.selectedProduct.childsComposition != null &&
                    widget.selectedProduct.childsComposition?.length !=
                        widget.indexOfLeftItem)
                  Expanded(
                    child: ChildsRadios(
                      selectedProduct: widget.selectedProduct,
                      selectedFather: _selectedFather(
                          widget.selectedProduct, widget.indexOfLeftItem),
                      callSetState: () {
                        setState(() {});
                      },
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
                  productHasComment: productHasComment,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

ProductCompositionViewModel _selectedFather(
        ProductsViewModel selectedProduct, int indexOfLeftItem) =>
    selectedProduct.childsComposition![indexOfLeftItem];

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

bool _showUpdateQuantity({
  required ProductsViewModel selectedProduct,
  required int indexOfSelectedFather,
  required bool productHasComment,
}) {
  if (selectedProduct.childsComposition == null) {
    if (indexOfSelectedFather == 0 && productHasComment) {
      return false;
    } else {
      return true;
    }
  }

  if (indexOfSelectedFather == selectedProduct.childsComposition!.length) {
    return true;
  } else {
    return false;
  }
}
