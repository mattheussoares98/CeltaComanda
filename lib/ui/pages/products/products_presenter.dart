import 'package:flutter/material.dart';

import '../../../ui/pages/pages.dart';
import '../../helpers/helpers.dart';

abstract class ProductsPresenter with ChangeNotifier implements Listenable {
  Stream<List<ProductsViewModel>> get productsStream;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;

  Future<void> load(int? expansibleGroupId);

  Future<bool> updateSaleRequest({
    required ProductsViewModel productsViewModel,
    required HomePresenter homePresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
    required String? productComment,
  });

  void goToComboxPage(ProductsViewModel product);
}
