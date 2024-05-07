import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import '../../../ui/pages/pages.dart';

abstract class ExpansibleGroupsPresenter
    with ChangeNotifier
    implements Listenable {
  List<ExpansibleGroupsViewModel> get expansibleGroups;

  Future<void> load(String commandNumber);
  Future<ProductsViewModel> searchProduct(String value);

  void goToProductsPage(ExpansibleGroupEntity entity);
  void clear();
}
