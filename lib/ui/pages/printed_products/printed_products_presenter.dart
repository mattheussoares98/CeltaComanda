import 'dart:typed_data';

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
  double getTotalLiquid(PrintedViewModel? printed);
  double getSubtotal(PrintedViewModel? printed);
  double getServiceChargeValue(PrintedViewModel? printed);

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

  Future<void> validateUserAndPermissionToCancelProducts({
    required int personalizedCode,
    required String password,
  });

  Future<void> removeServiceCharge({
    required int userPersonalizedCode,
    required String password,
    required String commandNumber,
    required PrintedViewModel printed,
    required bool validateUserAndPassword,
  });

  Future<void> printPrintedProducts(Uint8List bitmap);

  void goToPrintProductsPage();
}
