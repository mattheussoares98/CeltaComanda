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
            height: 400,
            width: 400,
            isAlcoholic:
                productsViewModel.IsAlcoholicProduct.toString() == "true",
          ),
        ),
      ),
      Expanded(
        flex: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
                child:
                    _productNamePriceAndComplement(productsViewModel, context)),
            if (productsViewModel.IsPromoCombox == "true")
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: _mountCombox(context),
              ),
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
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
            height: double.infinity,
            width: double.infinity,
            isAlcoholic:
                productsViewModel.IsAlcoholicProduct.toString() == "true",
          ),
        ),
      ),
      Expanded(
        flex: 3,
        child: _productNamePriceAndComplement(productsViewModel, context),
      ),
      if (productsViewModel.IsPromoCombox == "true") _mountCombox(context),
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
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Text(
        productsViewModel.Name,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: getStringSize(context) * (hasMinWidth(context) ? 2 : 1),
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
            maxLines: hasMinWidth(context) ? 4 : 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: hasMinWidth(context) ? 14 : 12,
              color: Theme.of(context).primaryColorDark,
              fontStyle: FontStyle.italic,
            ),
          ),
        )
    ],
  );
}

Widget _mountCombox(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: FittedBox(
      child: Text(
        "MONTAR COMBO",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).secondaryHeaderColor,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          fontSize: hasMinWidth(context) ? 20 : 17,
        ),
      ),
    ),
  );
}
