import 'package:flutter/material.dart';

abstract class ProductDetailsPresenter implements Listenable {
  Stream<String?> get navigateToStream;
  Stream<bool> get isLoadingStream;

  void goToCartPage();
  void addProductInCart();
}
