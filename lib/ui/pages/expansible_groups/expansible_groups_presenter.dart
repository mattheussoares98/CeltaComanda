import 'package:flutter/material.dart';

import './expansible_groups.dart';

abstract class ExpansibleGroupsPresenter implements Listenable {
  Stream<List<ExpansibleGroupsViewModel>> get expansibleGroupsStream;
  Stream<bool> get isLoadingStream;

  Future<void> loadExpansibleGroups();
  void goToProductsPage();
  void goToCartPage();
  void goToSplashPage();
}
