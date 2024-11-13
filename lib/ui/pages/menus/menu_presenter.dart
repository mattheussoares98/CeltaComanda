import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
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

  Stream<ProductScheduleViewModel?> get productScheduleStream;

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
  bool getAlreadyContainsExpansibleGroupName(String expansibleGroupName);
  String? getSubgroup(ExpansibleGroupEntity expansibleGroupEntity);
  Future<void> insertUpdateProductSchedule(
    int internalCodeOnErp,
  );
  void updateProductSchedule({
    required int internalCodeOnErp,
    bool? monday,
    bool? tuesday,
    bool? wednesday,
    bool? thursday,
    bool? friday,
    bool? saturday,
    bool? sunday,
  });
}
