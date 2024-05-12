import '../../helpers/helpers.dart';

import 'package:flutter/material.dart';

import '../pages.dart';

abstract class PrintedProductsPresenter
    with ChangeNotifier
    implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  bool get canCancelProducts;

  void updateCanCancelProducts(bool value);
  Future<void> load(String commandNumber);
  void clear();
  PrintedViewModel? get printedProducts;

  Future<void> removeProduct({
    required String saleRequestProductId,
    required ExpansibleGroupsPresenter expansibleGroupsPresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required HomePresenter homePresenter,
  });

  Future<void> validateUserAndPermissionToCancelProducts({
    required int personalizedCode,
    required String password,
  });
}
