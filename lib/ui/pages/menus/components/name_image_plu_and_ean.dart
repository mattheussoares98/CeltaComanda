import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';

import '../../pages.dart';
import '../../../components/components.dart';

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
      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
          textAlign: TextAlign.left,
        ),
        if (productsViewModel.EanCode != null)
          Text(
            productsViewModel.EanCode!,
            textAlign: TextAlign.left,
          ),
        Text(
          productsViewModel.SaleRetailPraticed.addBrazilianCoin(),
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontWeight: FontWeight.bold,
              fontSize: 17,
              shadows: const [
                Shadow(
                    color: Colors.black,
                    blurRadius: 0.2,
                    offset: Offset(0.03, 0.03)),
                Shadow(
                    color: Colors.black,
                    blurRadius: 0.2,
                    offset: Offset(-0.03, -0.03)),
              ]),
        ),
      ],
    );
  }
}
