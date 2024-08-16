import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class TitleText extends StatelessWidget {
  final int indexOfAtualOption;
  final ProductsViewModel selectedProduct;
  const TitleText({
    required this.indexOfAtualOption,
    required this.selectedProduct,
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

  String getTitleText({
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
    required InsertProductPresenter insertProductPresenter,
  }) {
    bool showComments = insertProductPresenter.getShowComments(
      expansibleGroupFromProductPresenter,
    );
    bool showObligatoryOptions =
        insertProductPresenter.getShowObligatoryOptions(
      expansibleGroupFromProductPresenter,
    );

    if (showComments) {
      return R.string.ifWantSelectComments;
    } else if (showObligatoryOptions) {
      return R.string.selectOneComment;
    } else if (selectedProduct.childsComposition == null) {
      return R.string.selectQuantity;
    } else {
      if (indexOfAtualOption == selectedProduct.childsComposition!.length) {
        return R.string.selectQuantity;
      } else if (indexOfAtualOption < selectedProduct.childsComposition!.length &&
          !showComments) {
        if (getSelectedFather(selectedProduct, indexOfAtualOption)
                .IsOptionalItem ==
            "false") {
          return R.string.selectProduct;
        } else {
          return R.string.ifWantSelectProducts;
        }
      }
    }
    return R.string.selectProduct;
  }

  @override
  Widget build(BuildContext context) {
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter =
        Provider.of(context, listen: false);
    InsertProductPresenter insertProductPresenter =
        Provider.of(context, listen: false);

    return Text(
      getTitleText(
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        insertProductPresenter: insertProductPresenter,
      ),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: getStringSize(context) * 1.4,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
