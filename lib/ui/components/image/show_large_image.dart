import 'package:clean_celta_mobile/ui/components/components.dart';
import 'package:flutter/material.dart';

import '../../../ui/helpers/helpers.dart';
import '../../pages/pages.dart';

void showLargeImage({
  required BuildContext context,
  required String? ean,
  required String? productComplement,
  ProductsViewModel? selectedProduct,
  bool? showInsertButton,
  required String plu,
  required MenuPresenter menuPresenter,
  String? productName,
}) {
  PersonalizedDialogPage.open(
      context: context,
      page: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if (productName != null)
              Text(
                productName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: hasMinWidth(context) ? 40 : 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ImageWidget(
                      ean: ean,
                      plu: plu,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      selectedProduct: selectedProduct,
                    ),
                  ),
                ],
              ),
            ),
            if (selectedProduct != null)
              _complementAndInsertProductButton(
                productComplement: productComplement,
                context: context,
                selectedProduct: selectedProduct,
                showInsertButton: showInsertButton == true,
              ),
          ],
        ),
      ));
}

Widget _complementAndInsertProductButton({
  required String? productComplement,
  required BuildContext context,
  required ProductsViewModel selectedProduct,
  required bool showInsertButton,
}) {
  if (hasMinWidth(context)) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (productComplement != null)
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ProductComplement(productComplement: productComplement),
              ),
            ),
          if (showInsertButton)
            Expanded(
              child: OpenInsertProductPage(
                selectedProduct: selectedProduct,
              ),
            ),
        ],
      ),
    );
  } else {
    return Column(
      children: [
        if (productComplement != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ProductComplement(productComplement: productComplement),
          ),
        if (showInsertButton)
          OpenInsertProductPage(selectedProduct: selectedProduct),
      ],
    );
  }
}
