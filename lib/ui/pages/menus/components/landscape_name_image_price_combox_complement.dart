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
        Expanded(
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
              Row(
                children: [
                  Flexible(
                    child: Text(
                      productsViewModel.Name,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: getStringSize(context) *
                            (hasMinWidth(context) ? 1.5 : 1.2),
                      ),
                    ),
                  ),
                  Text(
                    productsViewModel.SaleRetailPraticed.addBrazilianCoin(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                      fontWeight: FontWeight.bold,
                      fontSize: getStringSize(context) * 1.2,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (productsViewModel.IsPromoCombox == "true")
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: FittedBox(
                          child: Text(
                            "(${R.string.combox})",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              fontSize: getStringSize(context) * 1.2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              ProductComplement(
                productComplement: productsViewModel.ProductComplement,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
