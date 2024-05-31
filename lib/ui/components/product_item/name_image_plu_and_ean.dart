import 'package:flutter/material.dart';

import '../../../ui/pages/pages.dart';
import '../components.dart';

class NameImagePluAndEan extends StatelessWidget {
  final ProductsViewModel productsViewModel;
  const NameImagePluAndEan({
    required this.productsViewModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          productsViewModel.Name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        ImageWidget(
          ean: productsViewModel.EanCode,
          plu: productsViewModel.PriceLookupCode,
          height: 40,
          width: 40,
          showLargeImageInShowDialog: false,
        ),
        Text(
          productsViewModel.PriceLookupCode,
        ),
        if (productsViewModel.EanCode != null)
          Text(
            productsViewModel.EanCode!,
          ),
      ],
    );
  }
}
