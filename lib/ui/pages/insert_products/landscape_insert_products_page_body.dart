import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/helpers/helpers.dart';
import '../pages.dart';

class LandscapeInsertProductsPageBody extends StatefulWidget {
  final List<InsertProductsViewModel>? insertProductsViewModel;
  final ProductsViewModel selectedProduct;
  final double totalLiquid;
  final int indexOfAtualOption;
  const LandscapeInsertProductsPageBody({
    required this.insertProductsViewModel,
    required this.selectedProduct,
    required this.totalLiquid,
    required this.indexOfAtualOption,
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
              if (widget.insertProductsViewModel != null)
                Expanded(
                  child: OptionItems(
                    selectedProduct: widget.selectedProduct,
                    indexOfAtualOption: widget.indexOfAtualOption,
                    insertProductsViewModel: widget.insertProductsViewModel!,
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
                    widget.indexOfAtualOption <
                        widget.selectedProduct.childsComposition!.length)
                  Text(
                    _selectedFather(
                            widget.selectedProduct, widget.indexOfAtualOption)
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
                    insertProductsViewModel: widget
                        .insertProductsViewModel![widget.indexOfAtualOption],
                  ),
                Expanded(
                  child: CommentsList(
                    selectedProduct: widget.selectedProduct,
                    selectedLeftIndex: widget.indexOfAtualOption,
                  ),
                ),
                Expanded(
                  child: ObligatoryOptions(
                    selectedProduct: widget.selectedProduct,
                    selectedLeftIndex: widget.indexOfAtualOption,
                  ),
                ),
                const Expanded(child: UpdateQuantity()),
                Expanded(
                  child: ChildsRadios(
                    selectedProduct: widget.selectedProduct,
                    selectedFather: _selectedFather(
                        widget.selectedProduct, widget.indexOfAtualOption),
                    callSetState: () {
                      setState(() {});
                    },
                  ),
                ),
                AdvanceButton(
                  totalPrice: widget.totalLiquid,
                  quantity: insertProductPresenter.totalProductsQuantity,
                  selectedProduct: widget.selectedProduct,
                  leftSelectedIndex: widget.indexOfAtualOption,
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
        ProductsViewModel selectedProduct, int indexOfAtualOption) =>
    selectedProduct.childsComposition![indexOfAtualOption];
