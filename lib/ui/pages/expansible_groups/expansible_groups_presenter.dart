import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import './expansible_groups.dart';

abstract class ExpansibleGroupsPresenter with ChangeNotifier implements Listenable {
  List<ExpansibleGroupsViewModel> get expansibleGroups;
  SaleRequestTempViewModel? get saleRequestTemp;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;

  Future<void> getExpansibleGroups();
  Future<void> clearEnterpriseData();
  Future<void> load(String commandNumber);
  Future<void> getPrintedProducts(String commandNumber);

  Future<void> goToSplashPage();

  void goToProductsPage(int expansibleGroupId);
  void goToCartPage();
  void goToPrintedProductsPage();
}
