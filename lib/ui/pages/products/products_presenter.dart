import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import '../../../ui/pages/pages.dart';
import '../../helpers/helpers.dart';

abstract class ProductsPresenter implements Listenable {
  Stream<List<ProductsViewModel>> get productsStream;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  int? get indexOfSelectedProduct;

  void updateIndexOfSelectedProduct(int? index);
  Future<void> load(int? expansibleGroupId);

  Future<bool> updateSaleRequest({
    required UpdateSaleRequestTempEntity entity,
    required ExpansibleGroupsPresenter expansibleGroupsPresenter,
    required String comments,
    required int saleRequestProductTempId,
    required SaleRequestTempPresenter saleRequestTempPresenter,
  });
}
