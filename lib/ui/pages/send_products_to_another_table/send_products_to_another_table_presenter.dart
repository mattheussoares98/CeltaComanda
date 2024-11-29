import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class SendProductsToAnotherTablePresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<PrintedViewModel?> get printedProducts;

  List<int> get selectedsSaleRequestProductsIds;

  Future<void> loadProducts(int commandNumber);

  Future<void> sendProductsToAnotherTable({
    required int oldPersonalizedCode,
    required int newPersonalizedCode,
  });

  void updateProductIsSelected(int saleRequestProductId);

  void clearAllSelectedsSaleRequestProductsIds();
}
