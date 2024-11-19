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
      page: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                ImageWidget(
                  ean: ean,
                  plu: plu,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width * 1.3,
                  selectedProduct: selectedProduct,
                  zoomImage: false,
                ),
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black45,
                        Colors.transparent,
                        Colors.transparent,
                        Colors.transparent,
                      ],
                      end: Alignment.bottomCenter,
                      begin: Alignment.topCenter,
                    ),
                  ),
                ),
                if (productName != null)
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    child: Text(
                      productName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: hasMinWidth(context) ? 40 : 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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
      ));
}

Widget _complementAndInsertProductButton({
  required String? productComplement,
  required BuildContext context,
  required ProductsViewModel selectedProduct,
  required bool showInsertButton,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (productComplement != null &&
            productComplement.removeComplementConfigurations().isNotEmpty)
          Expanded(
            flex: 2,
            child: ProductComplement(
              productComplement: productComplement,
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
}
