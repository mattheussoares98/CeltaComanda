import 'package:flutter/material.dart';

import '../../../ui/pages/pages.dart';

abstract class CartPresenter implements Listenable {
  Stream<List<ProductsViewModel>> get cartProducts;
  Stream<bool> get isLoadingStream;

  void addProductInCart(ProductsViewModel product);
}
