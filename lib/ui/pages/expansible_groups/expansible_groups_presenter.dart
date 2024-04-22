import 'package:flutter/material.dart';

import './expansible_groups.dart';

abstract class ExpansibleGroupsPresenter implements Listenable {
  Stream<List<ExpansibleGroupsViewModel>> get expansibleGroupsStream;
  Stream<bool> get isLoadingStream;

  Future<void> load();
  void goToProductsPage(int expansibleGroupId);
  void goToCartPage();
  void goToSplashPage();

  Future<void> clearEnterpriseData();
}
