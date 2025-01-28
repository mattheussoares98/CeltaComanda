import 'package:flutter/material.dart';

import '../../../data/models/models.dart';
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

  Stream<ProductsViewModel?> get searchedProductStream;
  List<Map<ExpansibleGroupsViewModel, List<ProductsViewModel>>> get loadedMenu;

  Stream<ProductScheduleViewModel?> get productScheduleStream;
  Stream<ExpansibleGroupScheduleViewModel?> get expansibleGroupScheduleStream;

  List<ImageModel> get downloadedImages;

  Future<void> getGroupsAndProducts({
    required String commandNumber,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
  });
  Future<void> searchProduct(String value);
  Future<String> readBarcodeAndSearchProduct();

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
  Future<bool> insertUpdateProductSchedule({
    required int internalCodeOnErp,
    required int expansibleGroupId,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
    required HomePresenter homePresenter,
  });
  void updateProductScheduleStream({
    required int internalCodeOnErp,
    bool? monday,
    bool? tuesday,
    bool? wednesday,
    bool? thursday,
    bool? friday,
    bool? saturday,
    bool? sunday,
  });

  Future<bool> insertUpdateExpansibleGroupSchedule(int expansibleGroupId);
  void updateExpansibleGroupScheduleStream({
    required int expansibleGroupId,
    bool? monday,
    bool? tuesday,
    bool? wednesday,
    bool? thursday,
    bool? friday,
    bool? saturday,
    bool? sunday,
  });

  List<T> treatSchedules<T>();

  void cancelPreloadImage();

  Future<void> addOrRemoveSearchProducts();

  Future<void> loadAllImages();
}
