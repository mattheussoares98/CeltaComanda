import 'package:flutter/material.dart';

import '../../../ui/pages/pages.dart';

class PluAndEan extends StatelessWidget {
  final ProductsViewModel productsViewModel;
  const PluAndEan({
    required this.productsViewModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            productsViewModel.Name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            productsViewModel.PriceLookupCode,
          ),
          if (productsViewModel.EanCode != null)
            Text(
              productsViewModel.EanCode!,
            ),
        ],
      ),
    );
  }
}
