import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../../../ui/mixins/mixins.dart';
import '../../../../ui/pages/pages.dart';
import '../../../adapters/adapters.dart';

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

  InsertProductAdapter getInsertProductAdapter(
    InsertProductPresenter insertProductsPresenter,
    CommentsPresenter commentsPresenter,
  ) {
    return InsertProductAdapter(
        advanceSelectedIndex: () {
          insertProductsPresenter.advanceLeftIndex(commentsPresenter);
        },
        totalProductsQuantity: insertProductsPresenter.totalProductsQuantity,
        updateTotalLiquid: () {
          insertProductsPresenter.updateTotalLiquid(widget.selectedProduct);
        },
        totalPriceStream: insertProductsPresenter.totalPrice,
        doScrollStream: insertProductsPresenter.doScrollStream,
        showCommentsStream: insertProductsPresenter.showCommentsStream,
        selectedProduct: widget.selectedProduct,
        isLoadingStream: insertProductsPresenter.isLoadingStream,
        mainErrorStream: insertProductsPresenter.mainErrorStream,
        selectedComboxProductStream:
            insertProductsPresenter.selectedProductStream,
        selectedItemIndexStream:
            insertProductsPresenter.selectedLeftIndexStream,
        updateSelectedProduct: () {
          insertProductsPresenter.updateSelectedProduct(widget.selectedProduct);
        },
        doOnClosePage: () {
          insertProductsPresenter.clearData(
            product: widget.selectedProduct,
            commentsPresenter: commentsPresenter,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    InsertProductPresenter insertProductPresenter =
        Provider.of(context, listen: false);
    CommentsPresenter commentsPresenter = Provider.of(context, listen: false);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();

    loadingSubscription = handleLoading(context, cartPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, cartPresenter.mainErrorStream);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(),
      onPressed: () async {
        menuPresenter.goToInsertProductPage(
          getInsertProductAdapter(
            insertProductPresenter,
            commentsPresenter,
          ),
        );
        insertProductPresenter.updateSelectedProduct(widget.selectedProduct);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (hasMinWidth(context))
              Icon(
                Icons.shopping_cart,
                size: getIconSize(context),
              ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                hasMinWidth(context) ? "Inserir no carrinho" : "Inserir",
                style: TextStyle(
                  fontSize: getStringSize(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
