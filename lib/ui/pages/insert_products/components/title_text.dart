import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class TitleText extends StatelessWidget {
  final ProductsViewModel selectedProduct;
  final InsertProductsViewModel insertProductsViewModel;
  const TitleText({
    required this.selectedProduct,
    required this.insertProductsViewModel,
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
    final atualOption =
        insertProductsViewModel.selectedOptions.entries.first.key;

    if (atualOption == SelectedOptionType.optionalExpansibleGroup) {
      RegExp regex = RegExp(r'\(op\|(.*?)\|op\)');

      Match? match = regex.firstMatch(
          selectedProduct.ProductComplement.toString().toLowerCase());

      if (match != null) {
        return match.group(1)!;
      } else {
        return R.string.ifWantSelectComments;
      }
    } else if (atualOption == SelectedOptionType.obligatoryExpansibleGroup) {
      RegExp regex = RegExp(r'\(ob\|(.*?)\|ob\)');

      Match? match = regex.firstMatch(
          selectedProduct.ProductComplement.toString().toLowerCase());

      if (match != null) {
        return match.group(1)!;
      } else {
        return R.string.selectOneComment;
      }
    } else if (atualOption == SelectedOptionType.quantity) {
      return R.string.selectQuantity;
    } else if (atualOption == SelectedOptionType.fatherComposition) {
      final father =
          insertProductsViewModel.selectedOptions.entries.first.value;
      if ((father as ProductCompositionViewModel).IsOptionalItem == "false") {
        return R.string.selectProduct;
      } else {
        return R.string.ifWantSelectProducts;
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
