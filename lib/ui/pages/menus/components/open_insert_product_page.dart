import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../../../ui/mixins/mixins.dart';
import '../../../../ui/pages/pages.dart';

class OpenInsertProductPage extends StatefulWidget {
  final ProductsViewModel selectedProduct;
  const OpenInsertProductPage({
    required this.selectedProduct,
    super.key,
  });

  @override
  State<OpenInsertProductPage> createState() => _OpenInsertProductPageState();
}

class _OpenInsertProductPageState extends State<OpenInsertProductPage>
    with LoadingManager, UIErrorManager {
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;

  @override
  void dispose() {
    super.dispose();

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter =
        Provider.of(context, listen: false);
    InsertProductPresenter insertProductPresenter =
        Provider.of(context, listen: false);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();

    loadingSubscription = handleLoading(context, cartPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, cartPresenter.mainErrorStream);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(),
      onPressed: () async {
        Navigator.of(context).pop();
        await insertProductPresenter.updateSelectedProduct(
          product: widget.selectedProduct,
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter,
        );
        await menuPresenter.goToInsertProductPage(
          widget.selectedProduct,
          expansibleGroupFromProductPresenter,
        );
        menuPresenter.updateSuggestionsProducts(widget.selectedProduct);
      },
      child: Row(
        children: [
          Icon(
            Icons.shopping_cart,
            size: ScreenSize.hasMinWidth ? 35 : 25,
            color: Colors.white,
          ),
          if (ScreenSize.hasMinWidth)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  children: [
                    Text(
                      R.string.insert,
                      style: TextStyle(
                        fontSize: StringSize.size,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.selectedProduct.SaleRetailPraticed
                            .toDouble()
                            .toString()
                            .toBrazilianNumber()
                            .addBrazilianCoin(),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: StringSize.size,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (!ScreenSize.hasMinWidth)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FittedBox(
                      child: Text(
                        R.string.insert,
                        style: TextStyle(
                          fontSize: StringSize.size,
                        ),
                      ),
                    ),
                    FittedBox(
                      child: Text(
                        widget.selectedProduct.SaleRetailPraticed
                            .toDouble()
                            .toString()
                            .toBrazilianNumber()
                            .addBrazilianCoin(),
                        style: TextStyle(
                          fontSize: StringSize.size,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
