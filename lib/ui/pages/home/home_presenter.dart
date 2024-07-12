import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import '../../../ui/pages/pages.dart';
import '../../helpers/helpers.dart';

abstract class HomePresenter with ChangeNotifier implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;

  bool get isFixedCommandNumber;
  bool get isGeneratingVersionToRede;
  String? get commandNumber;
  void updateCommandNumber(String? value);
  Future<void> updateIsFixedCommandNumber();

  Future<void> clearEnterpriseData();

  Future<void> goToSplashPage({
    required PrintedProductsPresenter printedProductsPresenter,
    required CartPresenter cartPresenter,
    required MenuPresenter menuPresenter,
  });

  void goToProductsPage(ExpansibleGroupEntity entity);

  void onChangePage({
    required MenuPresenter menuPresenter,
    required CommentsPresenter commentsPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
  });

  Future<void> getLocalCommandData();
}
