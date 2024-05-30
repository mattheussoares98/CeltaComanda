import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import '../../../ui/pages/pages.dart';
import '../../helpers/helpers.dart';

abstract class ExpansibleGroupsPresenter
    with ChangeNotifier
    implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;

  Stream<int> get indexOfSelectedGroupStream;

  List<Map<ExpansibleGroupsViewModel, List<ProductsViewModel>>> get expansibleGroups;
  ProductsViewModel? get searchedProduct;

  TextEditingController get searchProductController;

  Future<void> getGroups(String commandNumber);
  Future<void> searchProduct(String value);
  Future<void> readBarcodeAndSearchProduct();
  Future<void> updateSaleRequest({
    required List<UpdateSaleRequestTempProductEntity> products,
    required HomePresenter homePresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
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
  void updateIndexOfSelectedGroup(int index);
}
