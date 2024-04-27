import 'package:flutter/material.dart';

import '../../../ui/pages/pages.dart';
import '../../helpers/helpers.dart';

abstract class ExpansibleGroupsPresenter
    with ChangeNotifier
    implements Listenable {
  List<ExpansibleGroupsViewModel> get expansibleGroups;
  SaleRequestTempViewModel? get saleRequestTemp;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;

  Future<void> getExpansibleGroups();
  Future<void> clearEnterpriseData();
  Future<void> load({
    required String commandNumber,
    required PrintedProductsPresenter printedProductsPresenter,
  });

  Future<void> goToSplashPage();

  void goToProductsPage(int expansibleGroupId);
  void goToCartPage();
  void goToPrintedProductsPage();
}
