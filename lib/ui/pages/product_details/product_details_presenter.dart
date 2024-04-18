import 'package:flutter/material.dart';

abstract class ProductDetailsPresenter implements Listenable {
  Stream<bool> get isLoadingStream;

  void goToCartPage();
  // void addProductInCart(ProductsViewModel product);
}
