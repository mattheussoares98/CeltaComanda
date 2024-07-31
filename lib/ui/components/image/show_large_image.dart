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
  AnimatedAlertDialog.open(
      context,
      Column(
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
                    isAlcoholic: selectedProduct != null &&
                        selectedProduct.IsAlcoholicProduct.toString() == "true",
                  ),
                ),
              ],
            ),
          ),
          if (selectedProduct != null && showInsertButton == true)
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (productComplement != null)
                    Expanded(
                      flex: 2,
                      child: _productComplement(context, productComplement),
                    ),
                  Expanded(
                    child: OpenInsertProductPage(
                      selectedProduct: selectedProduct,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ));
}

Widget _productComplement(BuildContext context, String productComplement) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            productComplement,
            style: TextStyle(
              fontSize: hasMinWidth(context) ? 20 : 12,
              color: Theme.of(context).primaryColorLight,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    ),
  );
}
