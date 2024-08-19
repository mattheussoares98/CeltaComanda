import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../ui/helpers/helpers.dart';
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

  final _scrollController = ScrollController();
  SelectedOptionType? atualOption;

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    InsertProductPresenter insertProductPresenter =
        Provider.of(context, listen: false);

    if (widget.insertProductsViewModel != null) {
      atualOption = widget.insertProductsViewModel![widget.indexOfAtualOption]
          .selectedOptions.keys.first;
    }

    return SingleChildScrollView(
      controller:
          _scrollController, //verificar se pode removar sem causar problemas, pois pelo jeito não usa
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              ImageAndComplement(selectedProduct: widget.selectedProduct),
              if (widget.insertProductsViewModel != null)
                OptionItems(
                  selectedProduct: widget.selectedProduct,
                  indexOfAtualOption: widget.indexOfAtualOption,
                  insertProductsViewModel: widget.insertProductsViewModel!,
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
                            if (atualOption ==
                                SelectedOptionType.fatherComposition)
                              Text(
                                _selectedFather(widget.selectedProduct,
                                        widget.indexOfAtualOption)
                                    .ChildName!,
                                style: TextStyle(
                                  fontSize: getStringSize(context) * 1.4,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).secondaryHeaderColor,
                                ),
                              ),
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AdvanceButton(
                          totalPrice: widget.totalLiquid,
                          quantity:
                              insertProductPresenter.totalProductsQuantity,
                          selectedProduct: widget.selectedProduct,
                          leftSelectedIndex: widget.indexOfAtualOption,
                          atualOption: atualOption,
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
              if (atualOption == SelectedOptionType.fatherComposition)
                ChildsRadios(
                  callSetState: () {
                    setState(() {});
                  },
                  selectedFather: _selectedFather(
                      widget.selectedProduct, widget.indexOfAtualOption),
                  selectedProduct: widget.selectedProduct,
                ),
              if (atualOption == SelectedOptionType.optionalExpansibleGroup)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: OptionalGroups(
                    selectedProduct: widget.selectedProduct,
                    selectedLeftIndex: widget.indexOfAtualOption,
                  ),
                ),
              if (atualOption == SelectedOptionType.obligatoryExpansibleGroup)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: ObligatoryGroups(
                    selectedProduct: widget.selectedProduct,
                    selectedLeftIndex: widget.indexOfAtualOption,
                  ),
                ),
              if (atualOption == SelectedOptionType.quantity)
                const UpdateQuantity(),
            ],
          ),
        ],
      ),
    );
  }
}

ProductCompositionViewModel _selectedFather(
        ProductsViewModel selectedProduct, int indexOfAtualOption) =>
    selectedProduct.childsComposition![indexOfAtualOption];
