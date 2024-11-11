import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class CancelProductsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<PrintedViewModel?> get printedProducts;

  Future<void> cancelProduct(String productId);
  Future<void> loadProducts(int commandNumber);
}
