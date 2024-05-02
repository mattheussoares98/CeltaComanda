import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import '../../../ui/pages/pages.dart';

abstract class ProductsPresenter implements Listenable {
  Stream<List<ProductsViewModel>> get productsStream;
  Stream<bool> get isLoadingStream;
  int? get indexOfSelectedProduct;

  void updateIndexOfSelectedProduct(int? index);
  void goToCartPage();
  Future<void> load(int? expansibleGroupId);

  Future<void> updateSaleRequest({
    required UpdateSaleRequestTempEntity entity,
    required SaleRequestTempPresenter saleRequestTempPresenter,
    required ExpansibleGroupsPresenter expansibleGroupsPresenter,
  });
}
