import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class CancelProductsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<PrintedViewModel?> get printedProducts;

  Future<void> cancelProduct({
    required String productId,
    required int commandNumber,
    required void Function() showSuccessMessage,
  });
  Future<void> loadProducts(int commandNumber);
}
