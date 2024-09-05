import 'package:clean_celta_mobile/ui/components/components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class PortraitNameImagePriceComboxComplement extends StatelessWidget {
  final ProductsViewModel productsViewModel;
  const PortraitNameImagePriceComboxComplement({
    required this.productsViewModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);

    return Column(
      children: [
        Row(
          children: [
            Flexible(
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
                  selectedProduct: productsViewModel,
                  height: 100,
                  width: 100,
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    productsViewModel.SaleRetailPraticed.addBrazilianCoin(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                      fontWeight: FontWeight.bold,
                      fontSize: getStringSize(context) * 1.2,
                    ),
                  ),
                  if (productsViewModel.IsPromoCombox == "true")
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
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
                    )
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            productsViewModel.Name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: getStringSize(context),
            ),
          ),
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
