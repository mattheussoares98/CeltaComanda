import 'package:flutter/material.dart';

import '../../../../main/builders/builders.dart';
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
        _Image(itemHeight: itemHeight, productsViewModel: productsViewModel),
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _ProductName(productsViewModel: productsViewModel),
                    ),
                    if (ScreenSize.hasMinWidth)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: _Price(productsViewModel: productsViewModel),
                      ),
                  ],
                ),
              ),
              if (!ScreenSize.hasMinWidth)
                Expanded(
                  child: Center(
                    child: _Price(productsViewModel: productsViewModel),
                  ),
                ),
              if (ScreenSize.hasMinWidth)
                Expanded(
                  child: Center(
                    child: ProductComplement(
                      productComplement: productsViewModel.ProductComplement,
                    ),
                  ),
                ),
              if (ScreenSize.hasMinWidth)
                _InsertProductButton(onTapInsertInCart: onTapInsertInCart),
            ],
          ),
        ),
      ],
    );
  }
}

class _InsertProductButton extends StatelessWidget {
  const _InsertProductButton({
    required this.onTapInsertInCart,
  });

  final Future<void> Function() onTapInsertInCart;

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

class _ProductName extends StatelessWidget {
  const _ProductName({
    required this.productsViewModel,
  });

  final ProductsViewModel productsViewModel;

  @override
  Widget build(BuildContext context) {
    return Text(
      EnterpriseBuilder.entity?.useReducedNameOnProduct == true
          ? (productsViewModel.NameReduced ?? productsViewModel.Name)
          : productsViewModel.Name,
      maxLines: 3,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: StringSize.size,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}

class _Image extends StatelessWidget {
  const _Image({
    required this.itemHeight,
    required this.productsViewModel,
  });

  final double itemHeight;
  final ProductsViewModel productsViewModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: itemHeight,
      width: itemHeight * (ScreenSize.hasMinWidth ? 1.5 : 1),
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
              width: itemHeight * (ScreenSize.hasMinWidth ? 1.5 : 0.9),
              selectedProduct: productsViewModel,
              zoomImage: true,
              orientation: AnimationOrientation.horizontal,
            ),
            if (ScreenSize.hasMinWidth)
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
    );
  }
}

class _Price extends StatelessWidget {
  const _Price({
    required this.productsViewModel,
  });

  final ProductsViewModel productsViewModel;

  bool get hasOfferPrice {
    if (productsViewModel.OfferRetailPrice == null) {
      return false;
    } else if ((productsViewModel.OfferRetailPrice?.toDouble() ?? 0) <= 0) {
      return false;
    } else if (productsViewModel.OfferRetailPrice ==
        productsViewModel.SaleRetailPraticed) {
      return false;
    }
    return true;
  }

  TextStyle get defaultStyle => TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: StringSize.size,
        color: Theme.of(NavigatorKey.key.currentState!.context).primaryColor,
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (hasOfferPrice)
          Text(
            productsViewModel.SaleRetailPrice.toString().addBrazilianCoin(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: StringSize.size,
              color: Theme.of(context).colorScheme.error,
              decoration: TextDecoration.lineThrough,
              decorationColor: Theme.of(context).colorScheme.error,
              fontStyle: FontStyle.italic,
            ),
          ),
        Text(
          productsViewModel.SaleRetailPraticed.addBrazilianCoin(),
          textAlign: TextAlign.center,
          style: hasOfferPrice
              ? TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: StringSize.size,
                )
              : defaultStyle,
        ),
      ],
    );
  }
}
