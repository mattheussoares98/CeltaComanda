import 'package:clean_celta_mobile/ui/helpers/sizes/sizes.dart';
import 'package:flutter/material.dart';

import '../../pages.dart';

class TitleText extends StatelessWidget {
  final int selectedLeftIndex;
  final ProductsViewModel selectedProduct;
  final bool showComments;
  final bool productHasComment;
  const TitleText({
    required this.selectedLeftIndex,
    required this.selectedProduct,
    required this.showComments,
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

  @override
  Widget build(BuildContext context) {
    return Text(
      getTitleText(),
      style: TextStyle(
        fontSize: getStringSize(context) * 1.4,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
