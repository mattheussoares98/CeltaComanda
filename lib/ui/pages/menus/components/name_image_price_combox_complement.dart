import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../../components/components.dart';
import '../../pages.dart';

class NameImagePriceComboxAndComplement extends StatelessWidget {
  final ProductsViewModel productsViewModel;
  const NameImagePriceComboxAndComplement({
    required this.productsViewModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context);
    CommentsPresenter commentsPresenter = Provider.of(context);

    if (hasMinWidth(context)) {
      return _landScapeNameImagePluAndCombox(
        context: context,
        productsViewModel: productsViewModel,
        menuPresenter: menuPresenter,
        commentsPresenter: commentsPresenter,
      );
    } else {
      return _portraitNameImagePluAndCombox(
        context: context,
        productsViewModel: productsViewModel,
        menuPresenter: menuPresenter,
        commentsPresenter: commentsPresenter,
      );
    }
  }
}

Widget _landScapeNameImagePluAndCombox({
  required BuildContext context,
  required ProductsViewModel productsViewModel,
  required MenuPresenter menuPresenter,
  required CommentsPresenter commentsPresenter,
}) {
  return Row(
    children: [
      Expanded(
        flex: 2,
        child: GestureDetector(
          onTap: () {
            _onTapImage(
              context: context,
              productsViewModel: productsViewModel,
              menuPresenter: menuPresenter,
              commentsPresenter: commentsPresenter,
            );
          },
          child: ImageWidget(
            ean: productsViewModel.EanCode,
            plu: productsViewModel.PriceLookupCode,
            height: 150,
            width: 150,
          ),
        ),
      ),
      Expanded(
        flex: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _productNamePriceAndComplement(productsViewModel, context),
            if (productsViewModel.IsPromoCombox == "true")
              _mountCombox(context),
          ],
        ),
      ),
    ],
  );
}

Widget _portraitNameImagePluAndCombox({
  required BuildContext context,
  required ProductsViewModel productsViewModel,
  required MenuPresenter menuPresenter,
  required CommentsPresenter commentsPresenter,
}) {
  return Column(
    children: [
      Expanded(
        flex: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                _onTapImage(
                  context: context,
                  productsViewModel: productsViewModel,
                  menuPresenter: menuPresenter,
                  commentsPresenter: commentsPresenter,
                );
              },
              child: ImageWidget(
                ean: productsViewModel.EanCode,
                plu: productsViewModel.PriceLookupCode,
                height: MediaQuery.of(context).size.width / 3 - 20,
                width: MediaQuery.of(context).size.width / 3,
              ),
            ),
            _productNamePriceAndComplement(productsViewModel, context),
            if (productsViewModel.IsPromoCombox == "true")
              _mountCombox(context),
          ],
        ),
      ),
    ],
  );
}

void _onTapImage({
  required BuildContext context,
  required ProductsViewModel productsViewModel,
  required MenuPresenter menuPresenter,
  required CommentsPresenter commentsPresenter,
}) {
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
  menuPresenter.updateSelectedProduct(
    selectedProduct: productsViewModel,
    commentsPresenter: commentsPresenter,
  );
}

Widget _productNamePriceAndComplement(
    ProductsViewModel productsViewModel, BuildContext context) {
  return Expanded(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          productsViewModel.Name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Text(
          productsViewModel.SaleRetailPraticed.addBrazilianCoin(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).primaryColorLight,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        if (productsViewModel.ProductComplement != null)
          Padding(
            padding: const EdgeInsets.all(2),
            child: Text(
              productsViewModel.ProductComplement!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: hasMinWidth(context) ? 20 : 14,
                color: Theme.of(context).primaryColorDark,
                fontStyle: FontStyle.italic,
              ),
            ),
          )
      ],
    ),
  );
}

Widget _mountCombox(BuildContext context) {
  return Text(
    "MONTAR COMBO",
    textAlign: TextAlign.center,
    style: TextStyle(
      color: Theme.of(context).secondaryHeaderColor,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      fontSize: hasMinWidth(context) ? 20 : 17,
    ),
  );
}
