import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../pages.dart';

class ImageAndComplement extends StatelessWidget {
  final ProductsViewModel selectedProduct;
  final double width;
  const ImageAndComplement({
    super.key,
    required this.selectedProduct,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: width,
          width: width,
          child: GestureDetector(
            onTap: () {
              showLargeImage(
                context: context,
                ean: selectedProduct.EanCode,
                plu: selectedProduct.PriceLookupCode,
                productComplement: selectedProduct.ProductComplement,
                productName: selectedProduct.Name,
                selectedProduct: selectedProduct,
                showInsertButton: false,
              );
            },
            child: ImageWidget(
              height: width,
              width: width,
              ean: selectedProduct.EanCode,
              plu: selectedProduct.PriceLookupCode,
              selectedProduct: selectedProduct,
            ),
          ),
        ),
        const SizedBox(width: 5),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ProductComplement(
                productComplement: selectedProduct.ProductComplement,
              ),
              const SizedBox(height: 5),
            ],
          ),
        )
      ],
    );
  }
}
