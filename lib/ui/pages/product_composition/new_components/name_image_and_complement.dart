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
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2.9,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              selectedProduct.Name,
              style: TextStyle(
                fontSize: getStringSize(context),
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
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
