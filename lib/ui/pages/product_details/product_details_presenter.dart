import 'package:flutter/material.dart';

import '../../../ui/pages/pages.dart';

abstract class ProductDetailsPresenter implements Listenable {
  Stream<bool> get isLoadingStream;

  void goToCartPage();
  Future<void> addProductInCart({
    required SaleRequestTempProductsViewModel product,
    required CartPresenter cartPresenter,
  });
}
