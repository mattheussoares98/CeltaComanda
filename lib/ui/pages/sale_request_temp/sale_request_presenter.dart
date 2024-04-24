import 'package:flutter/material.dart';

import '../pages.dart';

abstract class SaleRequestTempPresenter implements ChangeNotifier {
  List<ProductsViewModel> get saleRequestProducts;
  Stream<bool> get isLoadingStream;

  Future<void> addProductInCart(ProductsViewModel product);
}
