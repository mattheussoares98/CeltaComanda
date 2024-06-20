import '../../helpers/helpers.dart';

import 'package:flutter/material.dart';

import '../pages.dart';

abstract class PrintedProductsPresenter
    with ChangeNotifier
    implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<String?> get alertMessageStream;
  bool get canCancelProducts;

  void updateCanCancelProducts(bool value);
  Future<void> loadPrinted(String commandNumber);
  void clear();
  PrintedViewModel? get printedProducts;

  Future<void> removeProduct({
    required String saleRequestProductId,
    required MenuPresenter menuPresenter,
    required CartPresenter cartPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required HomePresenter homePresenter,
  });

  Future<void> loadCommandData({
    required PrintedProductsPresenter printedProductsPresenter,
    required CartPresenter cartPresenter,
    required MenuPresenter menuPresenter,
    required HomePresenter homePresenter,
    required bool clearPermissionToCancelProducts,
    required bool isRemovingProduct,
  });

  Future<void> validateUserAndPermissionToCancelProducts({
    required int personalizedCode,
    required String password,
  });
}
