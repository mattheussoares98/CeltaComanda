import 'package:clean_celta_mobile/ui/helpers/sizes/sizes.dart';
import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class TitleText extends StatelessWidget {
  final int indexOfLeftItem;
  final ProductsViewModel selectedProduct;
  final bool showComments;
  final bool productHasComment;
  const TitleText({
    required this.indexOfLeftItem,
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
      if (indexOfLeftItem == 0 && productHasComment) {
        return R.string.ifWantSelectComments;
      } else {
        return R.string.selectQuantity;
      }
    }

    if (indexOfLeftItem == selectedProduct.childsComposition!.length) {
      return R.string.selectQuantity;
    } else if (indexOfLeftItem < selectedProduct.childsComposition!.length &&
        !showComments) {
      if (getSelectedFather(selectedProduct, indexOfLeftItem).IsOptionalItem ==
          "false") {
        return R.string.selectProduct;
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
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: getStringSize(context) * 1.4,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
