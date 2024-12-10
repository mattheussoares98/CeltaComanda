import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class ConfigurationsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  int? get selectedPeoples;
  int? get selectedCommand;
  SellersViewModel? get selectedSeller;
  List<SellersViewModel> get sellers;

  Future<void> doLogout({
    required MenuPresenter menuPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required CartPresenter cartPresenter,
    required HomePresenter homePresenter,
  });
  Future<bool> openOrBlockadeCommand({
    required int commandNumber,
    required bool isOpen,
  });
  void updateSelectedPeoples(int? value);
  void updateSelectedCommand(int value);
  void updateSelectedSeller(SellersViewModel? seller);

  Future<void> goToCancelProductsPage();
  Future<void> goToSchedulesPage();

  Future<bool> loadMenuAgain();

  Future<bool> updateCommandData({
    required int newFixedCommandNumber,
    required int? peoples,
    required PrintedProductsPresenter printedProductsPresenter,
    required String? sellerCode,
    required HomePresenter homePresenter,
  });
  Future<bool> updateSaleRequestPersonalizedCode({
    required int oldPersonalizedCode,
    required int newPersonalizedCode,
  });

  void goToSendProductsToAnotherTablePage();

  Future<bool> closeCommand(int commandNumber);
  Future<void> goToParametersPage();
}
