import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import './expansible_groups.dart';

abstract class ExpansibleGroupsPresenter with ChangeNotifier implements Listenable {
  List<ExpansibleGroupsViewModel> get expansibleGroups;
  SaleRequestTempViewModel? get saleRequestTemp;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;

  Future<void> load();
  Future<void> clearEnterpriseData();
  Future<void> getSaleRequestTemp(String commandNumber);

  void goToProductsPage(int expansibleGroupId);
  void goToCartPage();
  void goToSplashPage();
}
