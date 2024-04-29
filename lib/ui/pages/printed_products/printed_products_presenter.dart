import '../../helpers/helpers.dart';

import 'package:flutter/material.dart';

import '../pages.dart';

abstract class PrintedProductsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;

  Future<bool> isValidPasswordAndCanCancel({
    required int personalizedCode,
    required String password,
  });
  Future<void> getPrintedProducts(String commandNumber);
  void clearPrintedProducts();
  PrintedViewModel? get printedProducts;

  Future<void> removeProduct({
    required int personalizedCode,
    required String password,
  });
}
