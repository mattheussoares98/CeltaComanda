import '../../../ui/pages/pages.dart';
import 'package:flutter/material.dart';

abstract class CartPresenter implements Listenable {
  Stream<List<ProductsViewModel>> get cartProducts;
  Stream<bool> get isLoadingStream;

  void addProductInCart(ProductsViewModel product);
}
