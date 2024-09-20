import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class MenuPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<bool> get showPreLoadImagesStream;
  Stream<bool> get doScrollGroupsStream;
  Stream<List<Map<ExpansibleGroupsViewModel, List<ProductsViewModel>>>>
      get menuStream;
  Stream<int> get indexOfSelectedGroupStream;

  ProductsViewModel? get searchedProduct;
  List<Map<ExpansibleGroupsViewModel, List<ProductsViewModel>>> get loadedMenu;

  TextEditingController get searchProductController;

  Future<void> getGroupsAndProducts({
    required String commandNumber,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
  });
  Future<void> searchProduct(String value);
  Future<void> readBarcodeAndSearchProduct();

  void goToInsertProductPage(ProductsViewModel product);
  void clear();
  void updateIndexOfSelectedGroup(int index);

  void updateSuggestionsProducts(ProductsViewModel selectedProduct);
  void advanceIndexOfAtualSuggestion();
  int get indexOfAtualSuggestion;
  List<ProductsViewModel> get suggestionsProductsViewModel;
  Stream<ProductsViewModel?> get atualSuggestionProductStream;

  String getExpansibleGroupNameWithoutPipes(String expansibleGroupName);
}
