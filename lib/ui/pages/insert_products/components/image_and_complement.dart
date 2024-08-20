import 'package:clean_celta_mobile/ui/helpers/sizes/sizes.dart';
import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class ImageAndComplement extends StatelessWidget {
  final ProductsViewModel selectedProduct;
  const ImageAndComplement({
    super.key,
    required this.selectedProduct,
  });

  @override
  Widget build(BuildContext context) {
    if (hasMinWidth(context)) {
      return Column(
        children: [
          ImageWidget(
            height: 160,
            width: 160,
            ean: selectedProduct.EanCode,
            plu: selectedProduct.PriceLookupCode,
            isAlcoholic: selectedProduct.IsAlcoholicProduct == "true",
            beginAnimation: 1.5,
            endAnimation: 1,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(3, 0, 3, 5),
            child: ProductComplement(
                productComplement: selectedProduct.ProductComplement),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Flexible(
            child: ImageWidget(
              height: 100,
              width: 100,
              ean: selectedProduct.EanCode,
              plu: selectedProduct.PriceLookupCode,
              isAlcoholic: selectedProduct.IsAlcoholicProduct == "true",
              beginAnimation: 1.2,
              endAnimation: 0.8,
            ),
          ),
          Expanded(
            flex: 2,
            child: ProductComplement(
                productComplement: selectedProduct.ProductComplement),
          )
        ],
      );
    }
  }
}
