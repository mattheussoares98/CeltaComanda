import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

double _getImageSize(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;

  if (width > height) {
    return height * 0.5;
  } else {
    return width * 0.8;
  }
}

void showSuggestionDialog(
  BuildContext context,
  ProductsViewModel product,
  MenuPresenter menuPresenter,
) {
  notificationDialog(
      canPop: false,
      context: context,
      titleMessage: R.string.doYouWantToAdd,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                product.Name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: StringSize.size,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ImageWidget(
              ean: product.EanCode,
              plu: product.PriceLookupCode,
              selectedProduct: product,
              height: _getImageSize(context),
              width: _getImageSize(context),
            ),
          ),
          Text(
              "${R.string.per} ${product.SaleRetailPraticed.toDouble().toString().toBrazilianNumber().addBrazilianCoin()}",
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
              )),
        ],
      ),
      onCancelPress: () async {
        menuPresenter.advanceIndexOfAtualSuggestion();
      },
      onPress: () async {
        await menuPresenter.goToInsertProductPage(
          product,
          Provider.of<ExpansibleGroupFromProductPresenter>(context,
              listen: false), //TODO test suggestion
        );
      });
}
