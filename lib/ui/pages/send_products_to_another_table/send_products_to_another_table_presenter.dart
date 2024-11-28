import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class SendProductsToAnotherTablePresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<PrintedViewModel?> get printedProducts;

  Future<void> loadProducts(int commandNumber);

  Future<void> sendProductsToAnotherTable({
    required int oldPersonalizedCode,
    required int newPersonalizedCode,
    required List<int> saleRequestProductsIds,
  });
}
