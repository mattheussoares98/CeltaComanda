import 'package:flutter/material.dart';

import '../../../ui/pages/pages.dart';

abstract class CartPresenter implements ChangeNotifier {
  List<ProductsViewModel> get cartProducts;
  Stream<bool> get isLoadingStream;

  Future<void> addProductInCart(ProductsViewModel product);
}
