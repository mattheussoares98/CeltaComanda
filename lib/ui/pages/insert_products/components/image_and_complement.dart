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
    return Row(
      children: [
        Flexible(
          child: ImageWidget(
            height: hasMinWidth(context) ? 160 : 100,
            width: hasMinWidth(context) ? 160 : 100,
            ean: selectedProduct.EanCode,
            plu: selectedProduct.PriceLookupCode,
            selectedProduct: selectedProduct,
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          flex: 2,
          child: Column(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ProductComplement(
                productComplement: selectedProduct.ProductComplement,
              ),
              const SizedBox(height: 5),
              PepperIndicator(product: selectedProduct),
            ],
          ),
        )
      ],
    );
  }
}
