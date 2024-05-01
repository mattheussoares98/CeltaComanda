import '../../helpers/helpers.dart';

import 'package:flutter/material.dart';

import '../pages.dart';

abstract class PrintedProductsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;

  Future<void> load(String commandNumber);
  void clear();
  PrintedViewModel? get printedProducts;

  Future<void> removeProduct({
    required int personalizedCode,
    required String password,
    required String saleRequestProductId,
  });
}
