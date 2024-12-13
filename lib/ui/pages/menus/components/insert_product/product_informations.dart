import 'package:flutter/material.dart';

import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class ProductInformations extends StatelessWidget {
  final ProductsViewModel product;
  const ProductInformations({
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "${product.Name} (${product.PackingAbbreviation})",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: StringSize.size,
          ),
        ),
        Text(
          product.SaleRetailPraticed.toDouble()
              .toString()
              .toBrazilianNumber()
              .addBrazilianCoin(),
          style: TextStyle(fontSize: StringSize.size),
        ),
        Text(
          "PLU ${product.PriceLookupCode}",
          style: TextStyle(fontSize: StringSize.size),
        ),
        if (product.EanCode != null && product.EanCode!.isNotEmpty)
          Text(
            "EAN ${product.EanCode!}",
            style: TextStyle(fontSize: StringSize.size),
          ),
        if (product.IsPromoCombox == "true")
          Text(
            R.string.msgCantAddCombox,
            style: TextStyle(
              color: Colors.red,
              fontSize: StringSize.size,
            ),
          ),
      ],
    );
  }
}
