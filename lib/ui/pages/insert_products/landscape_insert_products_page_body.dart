import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../components/components.dart';
import '../pages.dart';

class LandScapeInsertProductsPageBody extends StatefulWidget {
  final List<InsertProductsViewModel>? insertProductsViewModel;
  final ProductsViewModel selectedProduct;
  final double totalLiquid;
  final int indexOfAtualOption;
  const LandScapeInsertProductsPageBody({
    required this.insertProductsViewModel,
    required this.selectedProduct,
    required this.totalLiquid,
    required this.indexOfAtualOption,
    super.key,
  });

  @override
  State<LandScapeInsertProductsPageBody> createState() =>
      _LandScapeInsertProductsPageBodyState();
}

class _LandScapeInsertProductsPageBodyState
    extends State<LandScapeInsertProductsPageBody> {
  SelectedOptionType? atualOption;

  @override
  Widget build(BuildContext context) {
    InsertProductPresenter insertProductPresenter =
        Provider.of(context, listen: false);
    MenuPresenter menuPresenter = Provider.of(context, listen: false);

    if (widget.insertProductsViewModel != null) {
      atualOption = widget.insertProductsViewModel![widget.indexOfAtualOption]
          .selectedOptions.keys.first;
    }

    double leftSize = MediaQuery.of(context).size.width * 0.55;

    return LayoutBuilder(builder: (context, constraints) {
      double screenHeight = constraints.maxHeight;
      double imageHeight = screenHeight *
          (widget.selectedProduct.ProductComplement == null ? 0.6 : 0.4);
      double maxListViewHeight = screenHeight * 0.3;

      return Row(
        children: [
          SizedBox(
            width: leftSize,
            child: Column(
              children: [
                SizedBox(
                  child: GestureDetector(
                    onTap: () {
                      showLargeImage(
                        context: context,
                        ean: widget.selectedProduct.EanCode,
                        plu: widget.selectedProduct.PriceLookupCode,
                        productComplement:
                            widget.selectedProduct.ProductComplement,
                        menuPresenter: menuPresenter,
                        productName: widget.selectedProduct.Name,
                        selectedProduct: widget.selectedProduct,
                        showInsertButton: false,
                      );
                    },
                    child: ImageWidget(
                      ean: widget.selectedProduct.EanCode,
                      plu: widget.selectedProduct.PriceLookupCode,
                      width: leftSize,
                      height: imageHeight,
                      selectedProduct: widget.selectedProduct,
                    ),
                  ),
                ),
                Expanded(
                  child: ProductComplement(
                    productComplement: widget.selectedProduct.ProductComplement,
                  ),
                ),
                if (widget.insertProductsViewModel != null)
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: maxListViewHeight,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: OptionItems(
                            selectedProduct: widget.selectedProduct,
                            insertProductIndex: widget.indexOfAtualOption,
                            insertProductsViewModel:
                                widget.insertProductsViewModel!,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: TotalPrice(
                            totalLiquid: widget.totalLiquid,
                          ),
                        ),
                      ],
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
                  if (atualOption == SelectedOptionType.fatherComposition)
                    Text(
                      insertProductPresenter
                          .getLastSelectedFather(widget.indexOfAtualOption)!
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
                  if (atualOption == SelectedOptionType.optionalExpansibleGroup)
                    Expanded(
                      child: OptionalGroups(
                        selectedProduct: widget.selectedProduct,
                        selectedLeftIndex: widget.indexOfAtualOption,
                      ),
                    ),
                  if (atualOption ==
                      SelectedOptionType.obligatoryExpansibleGroup)
                    Expanded(
                      child: ObligatoryGroups(
                        selectedProduct: widget.selectedProduct,
                        selectedLeftIndex: widget.indexOfAtualOption,
                      ),
                    ),
                  if (atualOption == SelectedOptionType.quantity)
                    Expanded(
                        child: UpdateQuantity(
                      quantity: insertProductPresenter.totalProductsQuantity,
                      reduceQuantity: () {
                        insertProductPresenter
                            .updateTotalProductsQuantity(false);
                      },
                      addQuantity: () {
                        insertProductPresenter
                            .updateTotalProductsQuantity(true);
                      },
                    )),
                  if (atualOption == SelectedOptionType.fatherComposition)
                    Expanded(
                      child: ChildsRadios(
                        selectedProduct: widget.selectedProduct,
                        selectedFather: insertProductPresenter
                            .getLastSelectedFather(widget.indexOfAtualOption)!,
                        callSetState: () {
                          setState(() {});
                        },
                      ),
                    ),
                  if (widget.insertProductsViewModel != null)
                    AdvanceButton(
                      totalPrice: widget.totalLiquid,
                      quantity: insertProductPresenter.totalProductsQuantity,
                      selectedProduct: widget.selectedProduct,
                      leftSelectedIndex: widget.indexOfAtualOption,
                      atualOption: atualOption,
                      insertProductsViewModel: widget
                          .insertProductsViewModel![widget.indexOfAtualOption],
                    ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
