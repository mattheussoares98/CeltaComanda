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
  double get totalLiquid;
  double get serviceChargeValue;

  void updateCanCancelProducts(bool value);
  Future<void> loadPrinted(String commandNumber);
  void clear();
  void doOnClosePage();
  PrintedViewModel? get printed;

  Future<void> removeProduct({
    required String saleRequestProductId,
    required MenuPresenter menuPresenter,
    required CartPresenter cartPresenter,
    required String commandNumber,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
  });

  // Future<void> loadCommandData({
  //   required CartPresenter cartPresenter,
  //   required MenuPresenter menuPresenter,
  //   required HomePresenter homePresenter,
  //   required CommentsPresenter expansibleGroupFromProductPresenter,
  //   required bool clearPermissionToCancelProducts,
  //   required bool isRemovingProduct,
  // });

  Future<void> validateUserAndPermissionToCancelProducts({
    required int personalizedCode,
    required String password,
  });

  Future<void> removeServiceCharge({
    required int userPersonalizedCode,
    required String password,
    required String commandNumber,
    required int saleRequestId,
  });
}
