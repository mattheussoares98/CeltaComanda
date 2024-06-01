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
  Stream<String?> get productCommentStream;

  ProductsViewModel? get searchedProduct;
  List<Map<ExpansibleGroupsViewModel, List<ProductsViewModel>>> get loadedMenu;

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
  void updateSelectedProduct(ProductsViewModel? selectedProduct);
  void updateProductComment(String? newComment);
}
