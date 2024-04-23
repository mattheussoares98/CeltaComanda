import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import './expansible_groups.dart';

abstract class ExpansibleGroupsPresenter implements Listenable {
  Stream<List<ExpansibleGroupsViewModel>> get expansibleGroupsStream;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;

  Future<void> load();
  Future<void> clearEnterpriseData();
  Future<void> verifyCommandAvailable(int commandNumber);

  void goToProductsPage(int expansibleGroupId);
  void goToCartPage();
  void goToSplashPage();
}
