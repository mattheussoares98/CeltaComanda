import 'package:flutter/material.dart';

import '../../../ui/pages/pages.dart';
import '../../helpers/helpers.dart';

abstract class ExpansibleGroupsPresenter
    with ChangeNotifier
    implements Listenable {
  List<ExpansibleGroupsViewModel> get expansibleGroups;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  String? get commandNumber;

  Future<void> clearEnterpriseData();
  Future<void> load({
    required String commandNumber,
    required PrintedProductsPresenter printedProductsPresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
  });

  Future<void> goToSplashPage({
    required PrintedProductsPresenter printedProductsPresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
  });

  void goToProductsPage(int expansibleGroupId);
  void clear();
}
