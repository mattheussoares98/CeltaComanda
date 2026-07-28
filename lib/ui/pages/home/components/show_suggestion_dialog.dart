import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

void showSuggestionDialog(
  BuildContext context,
  ProductsViewModel product,
  MenuPresenter menuPresenter,
) {
  final double screenHeight = MediaQuery.sizeOf(context).height;
  final bool isShortScreen = screenHeight < 600;
  final bool showImage = screenHeight > 450;
  final double imageSize = isShortScreen
      ? (screenHeight * 0.2).clamp(50.0, 100.0)
      : (screenHeight * 0.35).clamp(100.0, 250.0);

  notificationDialog(
      canPop: false,
      context: context,
      titleMessage: R.string.doYouWantToAdd,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              product.Name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize:
                    isShortScreen ? StringSize.size * 0.8 : StringSize.size,
              ),
            ),
            if (showImage) ...[
              SizedBox(height: isShortScreen ? 8 : 20),
              Padding(
                padding: EdgeInsets.only(bottom: isShortScreen ? 8 : 20),
                child: ImageWidget(
                  ean: product.EanCode,
                  plu: product.PriceLookupCode,
                  selectedProduct: product,
                  height: imageSize,
                  width: imageSize,
                ),
              ),
            ] else
              const SizedBox(height: 12),
            Text(
                "${R.string.per} ${product.SaleRetailPraticed.toDouble().toString().toBrazilianNumber().addBrazilianCoin()}",
                style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: isShortScreen ? 14 : 16,
                )),
          ],
        ),
      ),
      onCancelPress: () async {
        menuPresenter.advanceIndexOfAtualSuggestion();
      },
      onPress: () async {
        await menuPresenter.goToInsertProductPage(
          product,
          Provider.of<ExpansibleGroupFromProductPresenter>(
            context,
            listen: false,
          ),
        );
      });
}
