import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages.dart';

class PortraitInsertProductsPageBody extends StatefulWidget {
  final ProductsViewModel selectedProduct;
  final int indexOfLeftItem;
  final double totalLiquid;
  final AsyncSnapshot<bool> snapshowShowComments;
  const PortraitInsertProductsPageBody({
    required this.selectedProduct,
    required this.indexOfLeftItem,
    required this.totalLiquid,
    required this.snapshowShowComments,
    super.key,
  });

  @override
  State<PortraitInsertProductsPageBody> createState() =>
      _PortraitInsertProductsPageBodyState();
}

class _PortraitInsertProductsPageBodyState
    extends State<PortraitInsertProductsPageBody> {
  final double buttonHeight = 50;
  bool showComments = false;
  bool productHasComment = false;

  @override
  Widget build(BuildContext context) {
    CommentsPresenter commentsPresenter = Provider.of(context, listen: false);
    InsertProductPresenter insertProductPresenter =
        Provider.of(context, listen: false);

    productHasComment = _producthasComment(
      indexOfLeftItem: widget.indexOfLeftItem,
      commentsPresenter: commentsPresenter,
      selectedProduct: widget.selectedProduct,
    );

    showComments = _showComments(
      snapshowShowComments: widget.snapshowShowComments,
      product: widget.selectedProduct,
      indexOfLeftItem: widget.indexOfLeftItem,
    );

    return SingleChildScrollView(
      child: Column(
        children: [
          ImageAndComplement(selectedProduct: widget.selectedProduct),
          LeftItems(
            selectedProduct: widget.selectedProduct,
            indexOfSelectedFather: widget.indexOfLeftItem,
            productHasComment: productHasComment,
          ),
          if (widget.selectedProduct.childsComposition != null &&
              widget.indexOfLeftItem <
                  widget.selectedProduct.childsComposition!.length &&
              !showComments)
            ChildsRadios(
              callSetState: () {
                setState(() {});
              },
              selectedFather: _getSelectedFather(
                  widget.selectedProduct, widget.indexOfLeftItem),
              selectedProduct: widget.selectedProduct,
            ),
          if (showComments && productHasComment)
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
              child: CommentsList(
                selectedProduct: widget.selectedProduct,
                selectedLeftIndex: widget.indexOfLeftItem,
              ),
            ),
          if (_showUpdateQuantity(
              selectedProduct: widget.selectedProduct,
              indexOfSelectedFather: widget.indexOfLeftItem,
              productHasComment: productHasComment))
            const UpdateQuantity(),
          SizedBox(
            height: buttonHeight,
            child: AdvanceButton(
              totalPrice: widget.totalLiquid,
              quantity: insertProductPresenter.totalProductsQuantity,
              advanceSelectedIndex: () {
                insertProductPresenter.advanceLeftIndex(commentsPresenter);
              },
              selectedProduct: widget.selectedProduct,
              leftSelectedIndex: widget.indexOfLeftItem,
              productHasComment: productHasComment,
            ),
          ),
        ],
      ),
    );
  }
}

bool _producthasComment({
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

bool _showComments({
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

ProductCompositionViewModel _getSelectedFather(
  ProductsViewModel selectedProduct,
  int indexOfSelectedFather,
) {
  ProductCompositionViewModel selectedFather =
      selectedProduct.childsComposition![0];

  if (indexOfSelectedFather < selectedProduct.childsComposition!.length) {
    selectedFather = selectedProduct.childsComposition![indexOfSelectedFather];
  }

  return selectedFather;
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
