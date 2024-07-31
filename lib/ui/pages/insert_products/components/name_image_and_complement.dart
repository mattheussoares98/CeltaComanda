import 'package:clean_celta_mobile/ui/helpers/sizes/sizes.dart';
import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class NameImageAndComplement extends StatelessWidget {
  final ProductsViewModel selectedProduct;
  const NameImageAndComplement({
    super.key,
    required this.selectedProduct,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            selectedProduct.Name,
            style: TextStyle(
              fontSize: getStringSize(context) * 1.4,
              fontWeight: FontWeight.bold,
            ),
          ),
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
            child: Text(
              selectedProduct.ProductComplement ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
                fontSize: getStringSize(context) * 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
