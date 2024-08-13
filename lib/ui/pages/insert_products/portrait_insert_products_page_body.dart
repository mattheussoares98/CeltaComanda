import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../ui/helpers/helpers.dart';
import '../pages.dart';

class PortraitInsertProductsPageBody extends StatefulWidget {
  final ProductsViewModel selectedProduct;
  final int indexOfLeftItem;
  final double totalLiquid;
  final AsyncSnapshot<bool> snapshowShowComments;
  final bool showUpdateQuantity;
  final bool showComments;
  final bool productHasComments;
  final bool productHasObligatoryOptions;
  final bool showObligatoryOptions;
  const PortraitInsertProductsPageBody({
    required this.selectedProduct,
    required this.indexOfLeftItem,
    required this.totalLiquid,
    required this.snapshowShowComments,
    required this.showUpdateQuantity,
    required this.showComments,
    required this.productHasComments,
    required this.productHasObligatoryOptions,
    required this.showObligatoryOptions,
    super.key,
  });

  @override
  State<PortraitInsertProductsPageBody> createState() =>
      _PortraitInsertProductsPageBodyState();
}

class _PortraitInsertProductsPageBodyState
    extends State<PortraitInsertProductsPageBody> {
  final double buttonHeight = 50;

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter =
        Provider.of(context, listen: false);
    InsertProductPresenter insertProductPresenter =
        Provider.of(context, listen: false);

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
                showComments:
                    widget.selectedProduct.childsComposition == null &&
                        widget.indexOfLeftItem == 0,
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
                              showComments: widget.showComments,
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
                            insertProductPresenter.advanceLeftIndex(
                                expansibleGroupFromProductPresenter);
                          },
                          selectedProduct: widget.selectedProduct,
                          leftSelectedIndex: widget.indexOfLeftItem,
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
                  !widget.showComments)
                ChildsRadios(
                  callSetState: () {
                    setState(() {});
                  },
                  selectedFather: _selectedFather(
                      widget.selectedProduct, widget.indexOfLeftItem),
                  selectedProduct: widget.selectedProduct,
                ),
              if (widget.showComments && widget.productHasComments)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: CommentsList(
                    selectedProduct: widget.selectedProduct,
                    selectedLeftIndex: widget.indexOfLeftItem,
                  ),
                ),
              if (widget.showObligatoryOptions &&
                  widget.productHasObligatoryOptions)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: ObligatoryOptions(
                    selectedProduct: widget.selectedProduct,
                    selectedLeftIndex: widget.indexOfLeftItem,
                  ),
                ),
              if (_showUpdateQuantity(
                showComments: widget.showComments,
                showObligatoryOptions: widget.showObligatoryOptions,
                product: widget.selectedProduct,
                indexOfSelectedFather: widget.indexOfLeftItem,
              ))
                const UpdateQuantity(),
            ],
          ),
        ],
      ),
    );
  }
}

bool _showUpdateQuantity({
  required bool showComments,
  required bool showObligatoryOptions,
  required ProductsViewModel product,
  required int indexOfSelectedFather,
}) {
  if (showComments || showObligatoryOptions) {
    return false;
  } else if (product.childsComposition == null) {
    return true;
  } else if (product.childsComposition!.length == indexOfSelectedFather) {
    return true;
  } else {
    return false;
  }
}

ProductCompositionViewModel _selectedFather(
        ProductsViewModel selectedProduct, int indexOfLeftItem) =>
    selectedProduct.childsComposition![indexOfLeftItem];
