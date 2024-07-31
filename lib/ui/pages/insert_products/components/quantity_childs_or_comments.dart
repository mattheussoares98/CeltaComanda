import 'package:flutter/material.dart';

import '../../pages.dart';

class QuantityChildsOrComments extends StatelessWidget {
  final int selectedLeftIndex;
  final ProductsViewModel selectedProduct;
  final bool showComments;
  final Function() callSetState;
  final bool productHasComment;
  const QuantityChildsOrComments({
    required this.selectedLeftIndex,
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

  String getTitleText() {
    if (selectedProduct.childsComposition == null) {
      if (selectedLeftIndex == 0 && productHasComment) {
        return "Se desejar, selecione um comentário";
      } else {
        return "Informe a quantidade";
      }
    }

    if (selectedLeftIndex == selectedProduct.childsComposition!.length) {
      return "Informe a quantidade";
    } else if (selectedLeftIndex < selectedProduct.childsComposition!.length &&
        !showComments) {
      if (getSelectedFather(selectedProduct, selectedLeftIndex)
              .IsOptionalItem ==
          "false") {
        return "Selecione um produto!";
      } else {
        return "Se desejar, selecione um produto";
      }
    } else {
      return "Se desejar, selecione comentários";
    }
  }

  bool showUpdateQuantity() {
    if (selectedProduct.childsComposition == null) {
      if (selectedLeftIndex == 0 && productHasComment) {
        return false;
      } else {
        return true;
      }
    }

    if (selectedLeftIndex == selectedProduct.childsComposition!.length) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleText(text: getTitleText()),
        if (showUpdateQuantity()) const UpdateQuantity(),
        if (selectedProduct.childsComposition != null &&
            selectedLeftIndex < selectedProduct.childsComposition!.length &&
            !showComments)
          ChildsRadios(
            callSetState: callSetState,
            selectedFather:
                getSelectedFather(selectedProduct, selectedLeftIndex),
            selectedProduct: selectedProduct,
          ),
        if (showComments && productHasComment)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CommentsList(
              selectedProduct: selectedProduct,
              selectedLeftIndex: selectedLeftIndex,
            ),
          ),
      ],
    );
  }
}
