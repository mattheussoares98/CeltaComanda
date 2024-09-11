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
                padding: const EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          Text(
                            productsViewModel.Name,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: getStringSize(context),
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          if (productsViewModel.IsPromoCombox == "true")
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 30),
                              child: FittedBox(
                                child: Text(
                                  "(${R.string.combox})",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    fontSize: getStringSize(context),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Text(
                      productsViewModel.SaleRetailPraticed.addBrazilianCoin(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: getStringSize(context),
                        color: Theme.of(context).primaryColor,
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
