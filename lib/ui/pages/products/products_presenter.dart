import 'package:flutter/material.dart';

import './products_view_model.dart';

abstract class ProductsPresenter implements Listenable {
  Stream<List<ProductsViewModel>> get productsStream;
  Stream<String?> get navigateToStream;

  void goToProductDetailsPage();
  Future<void> loadProducts();
}
