import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            showLargeImageInShowDialog: false,
            beginAnimation: 1,
            endAnimation: 0.7,
          ),
        ),
      ),
      Expanded(
        flex: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _productNameAndPrice(productsViewModel, context),
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
                showLargeImageInShowDialog: false,
                beginAnimation: 1,
                endAnimation: 0.7,
              ),
            ),
            _productNameAndPrice(productsViewModel, context),
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

Widget _productNameAndPrice(
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
      ],
    ),
  );
}

Widget _mountCombox(BuildContext context) {
  return Text(
    "MONTAR COMBO",
    style: TextStyle(
      color: Theme.of(context).secondaryHeaderColor,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      fontSize: 20,
    ),
  );
}
