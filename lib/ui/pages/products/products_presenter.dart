import 'package:flutter/material.dart';

import './products_view_model.dart';

abstract class ProductsPresenter implements Listenable {
  Stream<List<ProductsViewModel>> get productsStream;
  Stream<String?> get navigateToStream;
  Stream<bool> get isLoadingStream;
  ProductsViewModel? get selectedProduct;

  void goToProductDetailsPage();
  Future<void> loadProducts();
  void updateSelectedProduct(ProductsViewModel product);
}
