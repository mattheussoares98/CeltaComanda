import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import '../pages.dart';
import '../../helpers/helpers.dart';

abstract class MenuPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<bool> get showPreLoadImagesStream;
  Stream<List<Map<ExpansibleGroupsViewModel, List<ProductsViewModel>>>>
      get menuStream;
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

  void goToProductsPage(ExpansibleGroupEntity entity);
  Future<void> goToComboxPage(ProductsViewModel product);
  void clear();
  void updateIndexOfSelectedGroup(int index);
}
