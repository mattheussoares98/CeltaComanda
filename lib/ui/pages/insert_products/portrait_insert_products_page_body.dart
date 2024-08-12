import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../ui/helpers/helpers.dart';
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
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    ExpansibleGroupFromProductPresenter commentsPresenter = Provider.of(context, listen: false);
    InsertProductPresenter insertProductPresenter =
        Provider.of(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

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
      controller: _scrollController,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              ImageAndComplement(selectedProduct: widget.selectedProduct),
              FathersItems(
                selectedProduct: widget.selectedProduct,
                indexOfSelectedFather: widget.indexOfLeftItem,
                productHasComment: productHasComment,
                showComments: showComments,
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Column(
                          children: [
                            if (widget.selectedProduct.childsComposition !=
                                    null &&
                                widget.indexOfLeftItem <
                                    widget.selectedProduct.childsComposition!
                                        .length)
                              Text(
                                _selectedFather(widget.selectedProduct,
                                        widget.indexOfLeftItem)
                                    .ChildName!,
                                style: TextStyle(
                                  fontSize: getStringSize(context) * 1.4,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).secondaryHeaderColor,
                                ),
                              ),
                            TitleText(
                              indexOfLeftItem: widget.indexOfLeftItem,
                              selectedProduct: widget.selectedProduct,
                              showComments: showComments,
                              productHasComment: productHasComment,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AdvanceButton(
                          totalPrice: widget.totalLiquid,
                          quantity:
                              insertProductPresenter.totalProductsQuantity,
                          advanceSelectedIndex: () {
                            insertProductPresenter
                                .advanceLeftIndex(commentsPresenter);
                          },
                          selectedProduct: widget.selectedProduct,
                          leftSelectedIndex: widget.indexOfLeftItem,
                          productHasComment: productHasComment,
                        ),
                        Text(
                          widget.totalLiquid
                              .toString()
                              .toBrazilianNumber()
                              .addBrazilianCoin(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: getStringSize(context) * 1.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (widget.selectedProduct.childsComposition != null &&
                  widget.indexOfLeftItem <
                      widget.selectedProduct.childsComposition!.length &&
                  !showComments)
                ChildsRadios(
                  callSetState: () {
                    setState(() {});
                  },
                  selectedFather: _selectedFather(
                      widget.selectedProduct, widget.indexOfLeftItem),
                  selectedProduct: widget.selectedProduct,
                ),
              if (showComments && productHasComment)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
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
            ],
          ),
        ],
      ),
    );
  }
}

bool _producthasComment({
  required int indexOfLeftItem,
  required ExpansibleGroupFromProductPresenter commentsPresenter,
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

ProductCompositionViewModel _selectedFather(
        ProductsViewModel selectedProduct, int indexOfLeftItem) =>
    selectedProduct.childsComposition![indexOfLeftItem];
