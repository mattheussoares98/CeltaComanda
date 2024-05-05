import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class SaleRequestTempPresenter implements ChangeNotifier {
  SaleRequestTempViewModel? get saleRequestTemp;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;

  Future<void> load(String commandNumber);
  Future<void> addProductQuantity({
    required String url,
    required int saleRequestProductTempId,
    required String commandNumber,
  });
  Future<void> subtractProductQuantity({
    required String url,
    required int saleRequestProductTempId,
    required int productQuantity,
    required String commandNumber,
  });

  void clear();

  Future<void> updateComment({
    required String comments,
    required int saleRequestProductTempId,
    required ExpansibleGroupsPresenter expansibleGroupsPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
  });

  int? get indexOfSelectedProduct;

  void updateIndexOfSelectedProduct(int? index);
}
