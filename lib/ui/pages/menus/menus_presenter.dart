import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import '../pages.dart';
import '../../helpers/helpers.dart';

abstract class MenuPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<List<Map<ExpansibleGroupsViewModel, List<ProductsViewModel>>>> get menuStream;

  Stream<int> get indexOfSelectedGroupStream;

  List<Map<ExpansibleGroupsViewModel, List<ProductsViewModel>>> get loadedMenu;
  ProductsViewModel? get selectedProduct;

  TextEditingController get searchProductController;

  Future<void> getGroupsAndProducts(String commandNumber);
  Future<void> searchProduct(String value);
  Future<void> readBarcodeAndSearchProduct();

  Future<void> loadCommandData({
    required String commandNumber,
    required PrintedProductsPresenter printedProductsPresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
    required MenuPresenter menuPresenter,
    required HomePresenter homePresenter,
  });

  void goToProductsPage(ExpansibleGroupEntity entity);
  void goToComboxPage(ProductsViewModel product);
  void clear();
  void updateIndexOfSelectedGroup(int index);
}
