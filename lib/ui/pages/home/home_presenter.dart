import 'package:flutter/material.dart';

import '../../../ui/pages/pages.dart';
import '../../helpers/helpers.dart';

abstract class HomePresenter with ChangeNotifier implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;

  bool get isFixedCommandNumber;
  bool get isGeneratingVersionToRede;
  String? get commandNumber;
  int? get peoples;
  void updateCommandNumber(String? value);
  Future<void> updateIsFixedCommandNumber();
  Future<bool> updateFixedCommandNumber({
    required int newFixedCommandNumber,
    required int userPersonalizedCode,
    required String password,
    required PrintedProductsPresenter printedProductsPresenter,
  });

  Future<void> clearEnterpriseData();

  Future<void> goToSplashPage({
    required PrintedProductsPresenter printedProductsPresenter,
    required CartPresenter cartPresenter,
    required MenuPresenter menuPresenter,
  });

  void goToCartPage();
  void goToPrintedProductsPage();

  void onChangePage({
    required MenuPresenter menuPresenter,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
  });

  Future<void> getLocalCommandData();
  Future<void> loadCommandData({
    required MenuPresenter menuPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required HomePresenter homePresenter,
    required CartPresenter cartPresenter,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
  });
  Future<bool> isValidUserAndPassword({
    required int personalizedCode,
    required String password,
  });
}
