import 'package:flutter/material.dart';

import '../../../ui/pages/pages.dart';

abstract class ProductDetailsPresenter implements Listenable {
  Stream<bool> get isLoadingStream;

  void goToCartPage();
  void addProductInCart(ProductsViewModel product);
}
