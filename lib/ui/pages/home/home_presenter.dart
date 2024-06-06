import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import '../../../ui/pages/pages.dart';

abstract class HomePresenter with ChangeNotifier implements Listenable {
  String? get commandNumber;
  void updateCommandNumber(String? value);

  Future<void> clearEnterpriseData();

  Future<void> goToSplashPage({
    required PrintedProductsPresenter printedProductsPresenter,
    required CartPresenter cartPresenter,
    required MenuPresenter menuPresenter,
  });

  void goToProductsPage(ExpansibleGroupEntity entity);

  void onChangePage({
    required MenuPresenter menuPresenter,
  });
}
