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
  String? productName,
}) {
  final deviceHeight = MediaQuery.of(context).size.height;
  final deviceWidth = MediaQuery.of(context).size.width;

  PersonalizedDialogPage.open(
    context: context,
    page: Column(
      children: [
        SizedBox(
          height: productComplement?.isEmpty == true
              ? deviceHeight
              : deviceHeight * 0.4,
          width: deviceWidth,
          child: Stack(
            children: [
              ImageWidget(
                ean: ean,
                plu: plu,
                height: productComplement?.isEmpty == true
                    ? deviceHeight
                    : deviceHeight * 0.4,
                width: deviceWidth,
                selectedProduct: selectedProduct,
                zoomImage: false,
              ),
              Container(
                width: deviceWidth,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black12,
                      Colors.black26,
                    ],
                    end: Alignment.bottomCenter,
                    begin: Alignment.topCenter,
                  ),
                ),
                child: Text(
                  productName ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: StringSize.size,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (productComplement != null &&
            productComplement.removeComplementConfigurations().isNotEmpty)
          Expanded(
            child: ProductComplement(
              productComplement: productComplement,
            ),
          ),
        if (showInsertButton == true && selectedProduct != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OpenInsertProductPage(
              selectedProduct: selectedProduct,
            ),
          ),
      ],
    ),
  );
}
