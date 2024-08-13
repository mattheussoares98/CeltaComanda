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

  @override
  Widget build(BuildContext context) {
    ExpansibleGroupFromProductPresenter commentsPresenter =
        Provider.of(context, listen: false);
    InsertProductPresenter insertProductPresenter =
        Provider.of(context, listen: false);
    showComments = _getShowComments(
      snapshowShowComments: widget.snapshowShowComments,
      product: widget.selectedProduct,
      indexOfLeftItem: widget.indexOfLeftItem,
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
}) {
  if (selectedProduct.childsComposition != null &&
      indexOfSelectedFather == selectedProduct.childsComposition!.length) {
    return true;
  } else {
    return false;
  }
}
