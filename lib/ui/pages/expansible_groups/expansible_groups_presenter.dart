import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import '../../../ui/pages/pages.dart';
import '../../helpers/helpers.dart';

abstract class ExpansibleGroupsPresenter
    with ChangeNotifier
    implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;

  List<ExpansibleGroupsViewModel> get expansibleGroups;
  ProductsViewModel? get searchedProduct;

  TextEditingController get searchProductController;

  Future<void> loadGroups(String commandNumber);
  Future<void> searchProduct(String value);
  Future<void> readBarcodeAndSearchProduct();
  Future<void> updateSaleRequest({
    required ProductsViewModel productsViewModel,
    required HomePresenter homePresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
    required String? productComment,
    required double productQuantity,
  });
  Future<void> loadCommandData({
    required String commandNumber,
    required PrintedProductsPresenter printedProductsPresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
    required ExpansibleGroupsPresenter expansibleGroupsPresenter,
    required HomePresenter homePresenter,
  });

  void goToProductsPage(ExpansibleGroupEntity entity);
  void goToComboxPage(ProductsViewModel product);
  void clear();
}
