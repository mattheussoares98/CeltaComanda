import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';

import '../../pages.dart';
import '../../../components/components.dart';

class NameImagePriceAndCombox extends StatelessWidget {
  final ProductsViewModel productsViewModel;
  const NameImagePriceAndCombox({
    required this.productsViewModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: MediaQuery.of(context).orientation == Orientation.portrait
              ? 1
              : 2,
          child: GestureDetector(
            onTap: () {
              ImageWidget.showLargeImage(
                context: context,
                ean: productsViewModel.EanCode,
                plu: productsViewModel.PriceLookupCode,
                productComplement: productsViewModel.ProductComplement,
                showInsertButton: true,
                selectedProduct: productsViewModel.IsPromoCombox == "true"
                    ? null
                    : productsViewModel,
              );
            },
            child: ImageWidget(
              ean: productsViewModel.EanCode,
              plu: productsViewModel.PriceLookupCode,
              productComplement: productsViewModel.ProductComplement,
              height: 150,
              width: 150,
              showLargeImageInShowDialog: false,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
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
              Text(
                productsViewModel.SaleRetailPraticed.addBrazilianCoin(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              if (productsViewModel.IsPromoCombox == "true")
                Text(
                  "MONTAR COMBO",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
