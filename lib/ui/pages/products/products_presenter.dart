import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import '../../../ui/pages/pages.dart';
import '../../helpers/helpers.dart';

abstract class ProductsPresenter with ChangeNotifier implements Listenable {
  Stream<List<ProductsViewModel>> get productsStream;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;

  Future<void> load(int? expansibleGroupId);

  Future<void> updateSaleRequest({
    required ProductsViewModel productsViewModel,
    required HomePresenter homePresenter,
    required CartPresenter cartPresenter,
    required List<UpdateSaleRequestTempProductEntity> products,
  });

  void goToComboxPage(ProductsViewModel product);
}
