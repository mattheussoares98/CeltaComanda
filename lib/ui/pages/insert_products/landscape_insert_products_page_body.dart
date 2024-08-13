import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages.dart';

class LandscapeInsertProductsPageBody extends StatefulWidget {
  final ProductsViewModel selectedProduct;
  final int indexOfLeftItem;
  final double totalLiquid;
  final AsyncSnapshot<bool> snapshowShowComments;
  final bool showComments;
  final bool showObligatoryOptions;
  final bool showUpdateQuantity;
  final bool productHasComments;
  final bool productHasObligatoryOptions;
  const LandscapeInsertProductsPageBody({
    required this.selectedProduct,
    required this.indexOfLeftItem,
    required this.totalLiquid,
    required this.snapshowShowComments,
    required this.showComments,
    required this.showObligatoryOptions,
    required this.showUpdateQuantity,
    required this.productHasComments,
    required this.productHasObligatoryOptions,
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
    ExpansibleGroupFromProductPresenter commentsPresenter =
        Provider.of(context, listen: false);
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
              Expanded(
                child: FathersItems(
                  selectedProduct: widget.selectedProduct,
                  indexOfSelectedFather: widget.indexOfLeftItem,
                  showComments: widget.showComments,
                  productHasComments: widget.productHasComments,
                  productHasObligatoryOptions:
                      widget.productHasObligatoryOptions,
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
                    showComments: widget.showComments,
                    showObligatoryOptions: widget.showObligatoryOptions,
                  ),
                if (widget.showComments)
                  Expanded(
                    child: CommentsList(
                      selectedProduct: widget.selectedProduct,
                      selectedLeftIndex: widget.indexOfLeftItem,
                    ),
                  ),
                if (widget.showObligatoryOptions)
                  Expanded(
                    child: ObligatoryOptions(
                      selectedProduct: widget.selectedProduct,
                      selectedLeftIndex: widget.indexOfLeftItem,
                    ),
                  ),
                if (widget.showUpdateQuantity)
                  const Expanded(child: UpdateQuantity()),
                if (!widget.showComments &&
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
