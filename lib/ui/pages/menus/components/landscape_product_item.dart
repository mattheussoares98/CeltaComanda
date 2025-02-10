import 'package:flutter/material.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../../components/components.dart';
import '../../pages.dart';

class LandscapeProductItem extends StatelessWidget {
  final ProductsViewModel productsViewModel;
  final double itemHeight;
  final double itemWidth;
  final Future<void> Function() onTapInsertInCart;
  const LandscapeProductItem({
    required this.productsViewModel,
    required this.itemHeight,
    required this.itemWidth,
    required this.onTapInsertInCart,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: itemHeight,
          width: itemHeight * 1.5,
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
            child: Stack(
              children: [
                ImageWidget(
                  ean: productsViewModel.EanCode,
                  plu: productsViewModel.PriceLookupCode,
                  height: itemHeight,
                  width: itemHeight * 1.5,
                  selectedProduct: productsViewModel,
                  zoomImage: true,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    height: itemHeight,
                    width: itemHeight * 0.13,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        productsViewModel.Name, //TODO treat reducedName or not
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: StringSize.size,
                          color: Theme.of(context).primaryColor,
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
                          fontSize: StringSize.size,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 2, 8, 8),
                    child: ElevatedButton(
                      onPressed: () async {
                        await onTapInsertInCart();
                      },
                      child: Text(
                        R.string.insertInCart,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
