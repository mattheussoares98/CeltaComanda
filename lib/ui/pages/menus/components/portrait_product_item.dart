import 'package:clean_celta_mobile/ui/components/components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    MenuPresenter menuPresenter = Provider.of(context, listen: false);

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
                    menuPresenter: menuPresenter,
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
                          fontSize: getStringSize(context),
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
                          fontSize: getStringSize(context) * 1.2,
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
