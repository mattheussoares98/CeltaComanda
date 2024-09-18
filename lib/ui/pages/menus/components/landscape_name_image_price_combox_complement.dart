import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../../components/components.dart';
import '../../pages.dart';

class LandscapeNameImagePriceComboxAndComplement extends StatelessWidget {
  final ProductsViewModel productsViewModel;
  final double itemHeight;
  final double itemWidth;
  const LandscapeNameImagePriceComboxAndComplement({
    required this.productsViewModel,
    required this.itemHeight,
    required this.itemWidth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context);

    return Row(
      children: [
        Flexible(
          flex: 2,
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
              width: itemWidth * 1.15,
              selectedProduct: productsViewModel,
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: productsViewModel.Name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: getStringSize(context),
                            color: Theme.of(context).primaryColor,
                          ),
                          children: <TextSpan>[
                            if (productsViewModel.IsPromoCombox == "true")
                              TextSpan(
                                text: "   (${R.string.combox})",
                                style: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  fontSize: getStringSize(context),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        productsViewModel.SaleRetailPraticed.addBrazilianCoin(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: getStringSize(context),
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: ProductComplement(
                    productComplement: productsViewModel.ProductComplement,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
