import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import '../pages.dart';
import '../../helpers/helpers.dart';

abstract class MenuPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<List<Map<ExpansibleGroupsViewModel, List<ProductsViewModel>>>>
      get menuStream;
  Stream<ProductsViewModel?> get selectedProductStream;
  Stream<int> get indexOfSelectedGroupStream;

  ProductsViewModel? get searchedProduct;
  List<Map<ExpansibleGroupsViewModel, List<ProductsViewModel>>> get loadedMenu;

  TextEditingController get searchProductController;

  Future<void> getGroupsAndProducts({
    required String commandNumber,
    required CommentsPresenter commentsPresenter,
  });
  Future<void> searchProduct(String value);
  Future<void> readBarcodeAndSearchProduct();

  // Future<void> loadCommandData({
  //   required String commandNumber,
  //   required PrintedProductsPresenter printedProductsPresenter,
  //   required CartPresenter cartPresenter,
  //   required MenuPresenter menuPresenter,
  //   required HomePresenter homePresenter,
  //   required CommentsPresenter commentsPresenter,
  // });

  void goToProductsPage(ExpansibleGroupEntity entity);
  void goToComboxPage(ProductsViewModel product);
  void clear();
  void updateIndexOfSelectedGroup(int index);
  void updateSelectedProduct({
    required ProductsViewModel? selectedProduct,
    required CommentsPresenter commentsPresenter,
  });
}
