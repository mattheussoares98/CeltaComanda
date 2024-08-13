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
  bool showObligatoryOptions = false;
  bool productHasComment = false;
  bool productHasObligatoryOption = false;
  final _scrollController = ScrollController();

  void doOnBuildScreen(
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter,
  ) {
    productHasObligatoryOption =
        expansibleGroupFromProductPresenter.productHasObligatoryOption(
      indexOfChild: widget.indexOfLeftItem,
      product: widget.selectedProduct,
    );

    productHasComment = expansibleGroupFromProductPresenter.productHasComment(
      indexOfChild: widget.indexOfLeftItem,
      product: widget.selectedProduct,
    );

    showComments = false;
    showObligatoryOptions = false;

    if (widget.indexOfLeftItem == 0) {
      if (productHasComment &&
          widget.selectedProduct.childsComposition == null) {
        showComments = true;
      } else if (productHasObligatoryOption) {
        showObligatoryOptions = true;
      }
    } else if (widget.indexOfLeftItem == 1 && productHasObligatoryOption) {
      showObligatoryOptions = true;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter =
        Provider.of(context, listen: false);
    InsertProductPresenter insertProductPresenter =
        Provider.of(context, listen: false);

    doOnBuildScreen(expansibleGroupFromProductPresenter);

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
                              showComments: showComments,
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
              if (showObligatoryOptions && productHasObligatoryOption)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: ObligatoryOptions(
                    selectedProduct: widget.selectedProduct,
                    selectedLeftIndex: widget.indexOfLeftItem,
                  ),
                ),
              if (_showUpdateQuantity(
                showComments: showComments,
                showObligatoryOptions: showObligatoryOptions,
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
