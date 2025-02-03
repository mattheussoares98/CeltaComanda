import 'package:flutter/material.dart';

import '../../../../ui/components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class PortraitProductItem extends StatelessWidget {
  final ProductsViewModel productsViewModel;
  final double itemHeight;
  final double itemWidth;
  const PortraitProductItem({
    required this.productsViewModel,
    required this.itemHeight,
    required this.itemWidth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Flexible(
              flex: 40,
              child: GestureDetector(
                onTap: () {
                  showLargeImage(
                    context: context,
                    ean: productsViewModel.EanCode,
                    plu: productsViewModel.PriceLookupCode,
                    productComplement: productsViewModel.ProductComplement,
                    showInsertButton: true,
                    selectedProduct: productsViewModel,
                    productName: productsViewModel.Name,
                  );
                },
                child: ImageWidget(
                  ean: productsViewModel.EanCode,
                  plu: productsViewModel.PriceLookupCode,
                  height: itemHeight,
                  width: itemWidth,
                  selectedProduct: productsViewModel,
                ),
              ),
            ),
            Flexible(
              flex: 60,
              child: Padding(
                padding: const EdgeInsets.only(left: 2),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        productsViewModel.Name,
                        textAlign: TextAlign.center,
                        maxLines: 6,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: StringSize.size,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    FittedBox(
                      child: Text(
                        productsViewModel.SaleRetailPraticed.addBrazilianCoin(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                          fontWeight: FontWeight.bold,
                          fontSize: StringSize.size * 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (productsViewModel.ProductComplement?.isNotEmpty == true)
          Flexible(
            child: ProductComplement(
              productComplement: productsViewModel.ProductComplement,
            ),
          ),
      ],
    );
  }
}
