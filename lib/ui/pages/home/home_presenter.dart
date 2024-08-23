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
  List<SellersViewModel> get sellers;

  void updateCommandNumber(String? value);
  Future<void> updateIsFixedCommandNumber();
  Future<bool> updateCommandData({
    required int newFixedCommandNumber,
    required int userPersonalizedCode,
    required String password,
    required int? peoples,
    required PrintedProductsPresenter printedProductsPresenter,
    required String? sellerCode,
  });

  Future<void> clearEnterpriseData();

  Future<void> goToSplashPage({
    required PrintedProductsPresenter printedProductsPresenter,
    required CartPresenter cartPresenter,
    required MenuPresenter menuPresenter,
  });

  void goToCartPage();
  void goToPrintedProductsPage();
  void goToPaymentPage();

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

  Future<bool> openOrBlockadeCommand({
    required int commandNumber,
    required bool isOpen,
  });
}
