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
                TitleText(
                    text: getSelectedFather(
                                    selectedProduct, indexOfSelectedFather)
                                .IsOptionalItem ==
                            "false"
                        ? "Selecione um produto!"
                        : "Se desejar, selecione um produto"),
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
                const TitleText(text: "Se desejar, selecione comentários"),
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
