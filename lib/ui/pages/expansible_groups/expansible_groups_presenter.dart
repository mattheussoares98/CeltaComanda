import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import '../../../ui/pages/pages.dart';
import '../../helpers/helpers.dart';

abstract class ExpansibleGroupsPresenter
    with ChangeNotifier
    implements Listenable {
  List<ExpansibleGroupsViewModel> get expansibleGroups;
  Stream<UIError?> get mainErrorStream;
  Future<void> clearEnterpriseData();
  Future<void> load(String commandNumber);

  Future<void> goToSplashPage({
    required PrintedProductsPresenter printedProductsPresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
  });

  void goToProductsPage(ExpansibleGroupEntity entity);
  void clear();
}
