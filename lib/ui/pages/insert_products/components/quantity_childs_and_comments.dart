import 'package:clean_celta_mobile/ui/pages/insert_products/components/update_quantity.dart';
import 'package:flutter/material.dart';

import '../../pages.dart';
import '../../../helpers/helpers.dart';

class QuantityChildsAndComments extends StatelessWidget {
  final int selectedLeftIndex;
  final ProductsViewModel selectedProduct;
  final bool showComments;
  final Function() callSetState;
  final bool productHasComment;
  const QuantityChildsAndComments({
    required this.selectedLeftIndex,
    required this.selectedProduct,
    required this.showComments,
    required this.callSetState,
    required this.productHasComment,
    super.key,
  });

  InsertProductsViewModel getSelectedFather(
    ProductsViewModel selectedProduct,
    int indexOfSelectedFather,
  ) {
    InsertProductsViewModel selectedFather =
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
    return Expanded(
      child: Column(
        children: [
          TitleText(text: getTitleText()),
          if (showUpdateQuantity()) const UpdateQuantity(),
          if (selectedProduct.childsComposition != null &&
              selectedLeftIndex < selectedProduct.childsComposition!.length &&
              !showComments)
            Column(
              children: [
                ChildsRadios(
                  callSetState: callSetState,
                  selectedFather:
                      getSelectedFather(selectedProduct, selectedLeftIndex),
                  selectedProduct: selectedProduct,
                ),
              ],
            ),
          if (showComments && productHasComment)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CommentsList(
                internalCodeOnErp: selectedProduct.childsComposition == null
                    ? selectedProduct.InternalCodeOnERP!.toInt()
                    : selectedProduct.childsComposition![selectedLeftIndex]
                        .InternalCodeOnERPCodeChild!
                        .toInt(),
                selectedProductName: selectedProduct.childsComposition == null
                    ? selectedProduct.Name
                    : selectedProduct
                        .childsComposition![selectedLeftIndex].ChildName!,
              ),
            ),
        ],
      ),
    );
  }
}
