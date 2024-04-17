import 'package:flutter/material.dart';

import './products_view_model.dart';

abstract class ProductsPresenter implements Listenable {
  Stream<List<ProductsViewModel>> get productsStream;
  Stream<bool> get isLoadingStream;
  ProductsViewModel? get selectedProduct;

  void goToProductDetailsPage();
  void goToCartPage();
  Future<void> load();
  void updateSelectedProduct(ProductsViewModel product);
}
