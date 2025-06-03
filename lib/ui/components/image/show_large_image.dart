import 'package:flutter/material.dart';

import '../../../ui/components/components.dart';
import '../../../ui/helpers/helpers.dart';
import '../../pages/pages.dart';

void showLargeImage({
  required BuildContext context,
  required String? ean,
  required String? productComplement,
  ProductsViewModel? selectedProduct,
  bool? showInsertButton,
  required String plu,
  String? imagePath,
  String? productName,
}) {
  final deviceHeight = MediaQuery.of(context).size.height;
  final deviceWidth = MediaQuery.of(context).size.width;

  PersonalizedDialogPage.open(
    context: context,
    page: Column(
      children: [
        Text(
          productName ?? "",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: StringSize.size * 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          flex: 3,
          child: ImageWidget(
            imagePath: imagePath,
            ean: ean,
            plu: plu,
            height: productComplement != null && productComplement.isNotEmpty
                ? deviceHeight * 0.8
                : deviceHeight,
            width: deviceWidth,
            selectedProduct: selectedProduct,
            orientation: AnimationOrientation.vertical,
            zoomImage: true,
          ),
        ),
        // if (productComplement != null &&
        //     productComplement.removeComplementConfigurations().isNotEmpty)
        //   Expanded(
        //     child: ProductComplement(
        //       productComplement: productComplement,
        //     ),
        //   ),
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
