import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import '../../../ui/pages/pages.dart';

abstract class ExpansibleGroupsPresenter
    with ChangeNotifier
    implements Listenable {
  List<ExpansibleGroupsViewModel> get expansibleGroups;
  Future<void> load(String commandNumber);

  void goToProductsPage(ExpansibleGroupEntity entity);
  void clear();
}
