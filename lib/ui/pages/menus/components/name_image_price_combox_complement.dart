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
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter =
        Provider.of(context);

    if (hasMinWidth(context)) {
      return _landScapeNameImagePluAndCombox(
        context: context,
        productsViewModel: productsViewModel,
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    } else {
      return _portraitNameImagePluAndCombox(
        context: context,
        productsViewModel: productsViewModel,
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    }
  }
}

Widget _landScapeNameImagePluAndCombox({
  required BuildContext context,
  required ProductsViewModel productsViewModel,
  required MenuPresenter menuPresenter,
  required ExpansibleGroupFromProductPresenter
      expansibleGroupFromProductPresenter,
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
              expansibleGroupFromProductPresenter:
                  expansibleGroupFromProductPresenter,
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
        flex: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
                child:
                    _namePriceComboxAndComplement(productsViewModel, context)),
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
  required ExpansibleGroupFromProductPresenter
      expansibleGroupFromProductPresenter,
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
              expansibleGroupFromProductPresenter:
                  expansibleGroupFromProductPresenter,
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
        child: _namePriceComboxAndComplement(productsViewModel, context),
      ),
    ],
  );
}

void _onTapImage({
  required BuildContext context,
  required ProductsViewModel productsViewModel,
  required MenuPresenter menuPresenter,
  required ExpansibleGroupFromProductPresenter
      expansibleGroupFromProductPresenter,
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
}

Widget _namePriceComboxAndComplement(
    ProductsViewModel productsViewModel, BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Text(
        productsViewModel.Name,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: getStringSize(context) * (hasMinWidth(context) ? 1.5 : 1.2),
        ),
      ),
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            pepperIndicator(
              productsViewModel.ProductComplement,
            ),
            Expanded(
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
            if (productsViewModel.IsPromoCombox == "true")
              _mountCombox(
                context,
              ),
          ],
        ),
      ),
      if (productsViewModel.ProductComplement != null)
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                productsViewModel.ProductComplement!,
                maxLines: hasMinWidth(context) ? 4 : 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: getStringSize(context),
                  color: Theme.of(context).primaryColorDark,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300,
                ),
              ),
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
  );
}
