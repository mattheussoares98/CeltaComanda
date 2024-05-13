import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import '../../../ui/pages/pages.dart';

abstract class HomePresenter with ChangeNotifier implements Listenable {
  String? get commandNumber;
  void updateCommandNumber(String? value);

  Future<void> clearEnterpriseData();

  Future<void> goToSplashPage({
    required PrintedProductsPresenter printedProductsPresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
    required ExpansibleGroupsPresenter expansibleGroupsPresenter,
  });

  void goToProductsPage(ExpansibleGroupEntity entity);
}
