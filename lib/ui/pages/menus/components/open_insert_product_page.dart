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

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();

    loadingSubscription = handleLoading(context, cartPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, cartPresenter.mainErrorStream);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(),
      onPressed: () async {
        Navigator.of(context).pop();
        menuPresenter.goToInsertProductPage(widget.selectedProduct);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.shopping_cart,
              size: getIconSize(context),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      R.string.insert,
                      style: TextStyle(
                        fontSize: getStringSize(context),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.selectedProduct.SaleRetailPraticed
                          .toDouble()
                          .toString()
                          .toBrazilianNumber()
                          .addBrazilianCoin(),
                      style: TextStyle(
                        fontSize: getStringSize(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
