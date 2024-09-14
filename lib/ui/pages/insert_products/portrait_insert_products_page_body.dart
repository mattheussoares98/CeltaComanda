import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../ui/helpers/helpers.dart';
import '../../components/components.dart';
import '../pages.dart';

class PortraitInsertProductsPageBody extends StatefulWidget {
  final List<InsertProductsViewModel>? insertProductsViewModel;
  final ProductsViewModel selectedProduct;
  final double totalLiquid;
  final int indexOfAtualOption;
  const PortraitInsertProductsPageBody({
    required this.insertProductsViewModel,
    required this.selectedProduct,
    required this.totalLiquid,
    required this.indexOfAtualOption,
    super.key,
  });

  @override
  State<PortraitInsertProductsPageBody> createState() =>
      _PortraitInsertProductsPageBodyState();
}

class _PortraitInsertProductsPageBodyState
    extends State<PortraitInsertProductsPageBody> {
  final double buttonHeight = 50;

  ScrollController? _scrollController;
  SelectedOptionType? atualOption;
  bool _isDisposed = false;

  @override
  void dispose() {
    super.dispose();
    _scrollController?.dispose();
    _isDisposed = true;
  }

  void _animateToEnd(int secondsToWait) {
    Future.delayed(Duration(seconds: secondsToWait), () {
      if (_scrollController != null && !_isDisposed) {
        _scrollController!.animateTo(
          _scrollController!.position.maxScrollExtent,
          duration: const Duration(seconds: 1),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    InsertProductPresenter insertProductPresenter =
        Provider.of(context, listen: false);

    if (widget.insertProductsViewModel != null) {
      atualOption = widget.insertProductsViewModel![widget.indexOfAtualOption]
          .selectedOptions.keys.first;
    }

    _animateToEnd(1);

    return SingleChildScrollView(
      controller: _scrollController,
      child: StreamBuilder<bool>(
          stream: insertProductPresenter.doScrollStream,
          builder: (context, snapshot) {
            if (snapshot.data == true) {
              _animateToEnd(0);
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    ImageAndComplement(
                      selectedProduct: widget.selectedProduct,
                      width: 100,
                    ),
                    if (widget.insertProductsViewModel != null)
                      OptionItems(
                        selectedProduct: widget.selectedProduct,
                        insertProductIndex: widget.indexOfAtualOption,
                        insertProductsViewModel:
                            widget.insertProductsViewModel!,
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
                                  if (widget.insertProductsViewModel != null)
                                    TitleText(
                                      selectedProduct: widget.selectedProduct,
                                      insertProductsViewModel:
                                          widget.insertProductsViewModel![
                                              widget.indexOfAtualOption],
                                    ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (widget.insertProductsViewModel != null)
                                  AdvanceButton(
                                    totalPrice: widget.totalLiquid,
                                    quantity: insertProductPresenter
                                        .totalProductsQuantity,
                                    selectedProduct: widget.selectedProduct,
                                    leftSelectedIndex:
                                        widget.indexOfAtualOption,
                                    atualOption: atualOption,
                                    insertProductsViewModel:
                                        widget.insertProductsViewModel![
                                            widget.indexOfAtualOption],
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
                          ),
                        ],
                      ),
                    ),
                    if (atualOption == SelectedOptionType.fatherComposition)
                      ChildsRadios(
                        callSetState: () {
                          setState(() {});
                        },
                        selectedFather: insertProductPresenter
                            .getLastSelectedFather(widget.indexOfAtualOption)!,
                        selectedProduct: widget.selectedProduct,
                      ),
                    if (atualOption ==
                        SelectedOptionType.optionalExpansibleGroup)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: OptionalGroups(
                          selectedProduct: widget.selectedProduct,
                          selectedLeftIndex: widget.indexOfAtualOption,
                        ),
                      ),
                    if (atualOption ==
                        SelectedOptionType.obligatoryExpansibleGroup)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: ObligatoryGroups(
                          selectedProduct: widget.selectedProduct,
                          selectedLeftIndex: widget.indexOfAtualOption,
                        ),
                      ),
                    if (atualOption == SelectedOptionType.quantity)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.1,
                        ),
                        child: FittedBox(
                          child: UpdateQuantity(
                            quantity:
                                insertProductPresenter.totalProductsQuantity,
                            reduceQuantity: () {
                              insertProductPresenter
                                  .updateTotalProductsQuantity(false);
                            },
                            addQuantity: () {
                              insertProductPresenter
                                  .updateTotalProductsQuantity(true);
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            );
          }),
    );
  }
}
