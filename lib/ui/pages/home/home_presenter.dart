import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import '../../../ui/pages/pages.dart';
import '../../helpers/helpers.dart';

abstract class HomePresenter with ChangeNotifier implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;

  bool get isGeneratingVersionToRede;
  bool get isGeneratingVersionToGetNet;
  bool get isGeneratingVersionToTablet;
  bool get isGeneratingVersionToMicrosoftStore;
  int? get selectedPeoples;
  int? get selectedCommand;
  SellersViewModel? get selectedSeller;
  List<SellersViewModel> get sellers;
  int? get updateMenu;
  CommandEntity? get commandEntity;

  Future<void> updateCommandEntity({
    required String? commandNumber,
    required bool isFixedCommandNumber,
    required PdvEntity? pdv,
  });

  Future<void> clear();

  Future<void> doLogout({
    required PrintedProductsPresenter printedProductsPresenter,
    required CartPresenter cartPresenter,
    required MenuPresenter menuPresenter,
    required EnterprisePresenter enterprisePresenter,
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

  Future<void> loadCommandData({
    required MenuPresenter menuPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
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
    required int userCode,
    required String password,
  });

  void updateSelectedPeoples(int? value);
  void updateSelectedCommand(int value);
  void updateSelectedSeller(SellersViewModel? seller);

  Future<void> closeApp();
  void changeIsGeneratingVersionToRede(bool value);
  Future<void> doOnRemoteEnterpriseChanges({
    required Map<String, dynamic> data,
    required MenuPresenter menuPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required CartPresenter cartPresenter,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
    required EnterprisePresenter enterprisePresenter,
  });

  Future<void> goToConfigurationsPage({
    required int userPersonalizedCode,
    required String password,
  });

  Future<bool> applicationIsInLatestVersion();
}
