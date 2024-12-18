import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class CancelProductsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<PrintedViewModel?> get printedProducts;

  Future<void> cancelProduct({
    required PrintedProductsViewModel product,
    required int commandNumber,
    required void Function() showSuccessMessage,
    required CartPresenter cartPresenter,
    required HomePresenter homePresenter,
  });
  Future<void> loadProducts(int commandNumber);
}
