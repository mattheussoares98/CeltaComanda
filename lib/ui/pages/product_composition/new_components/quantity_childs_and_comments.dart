import 'package:flutter/material.dart';

import '../../../../ui/pages/pages.dart';
import '../../../helpers/helpers.dart';

class QuantityChildsAndComments extends StatelessWidget {
  final int indexOfSelectedFather;
  final ProductsViewModel selectedProduct;
  final bool showComments;
  final Function() callSetState;
  final bool productHasComment;
  const QuantityChildsAndComments({
    required this.indexOfSelectedFather,
    required this.selectedProduct,
    required this.showComments,
    required this.callSetState,
    required this.productHasComment,
    super.key,
  });

  Widget rightSideTitleText(String text, BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Text(
          text,
          style: TextStyle(
            color: Theme.of(context).primaryColorDark,
            fontWeight: FontWeight.bold,
            fontSize: getStringSize(context),
          ),
        ),
      );

  ProductCompositionViewModel getSelectedFather(
    ProductsViewModel selectedProduct,
    int indexOfSelectedFather,
  ) {
    ProductCompositionViewModel selectedFather =
        selectedProduct.childsComposition![0];

    if (indexOfSelectedFather < selectedProduct.childsComposition!.length) {
      selectedFather =
          selectedProduct.childsComposition![indexOfSelectedFather];
    }

    return selectedFather;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          if (indexOfSelectedFather ==
              selectedProduct.childsComposition!.length)
            const Center(child: Text("Quantidade")),
          if (indexOfSelectedFather <
                  selectedProduct.childsComposition!.length &&
              !showComments)
            Column(
              children: [
                rightSideTitleText(
                    getSelectedFather(selectedProduct, indexOfSelectedFather)
                                .IsOptionalItem ==
                            "false"
                        ? "Selecione um produto!"
                        : "Se desejar, selecione um produto",
                    context),
                Childs(
                  callSetState: callSetState,
                  selectedFather:
                      getSelectedFather(selectedProduct, indexOfSelectedFather),
                  selectedProduct: selectedProduct,
                ),
              ],
            ),
          if (showComments && productHasComment)
            Column(
              children: [
                rightSideTitleText(
                    "Se desejar, selecione comentários", context),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CommentsList(
                    internalCodeOnErp: selectedProduct
                        .childsComposition![indexOfSelectedFather]
                        .InternalCodeOnERPCodeChild!
                        .toInt(),
                    selectedProductName: selectedProduct
                        .childsComposition![indexOfSelectedFather].ChildName!,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
