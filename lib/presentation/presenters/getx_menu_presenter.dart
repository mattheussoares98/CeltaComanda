import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../main/builders/builders.dart';
import '../../presentation/mixins/mixins.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxMenuPresenter extends GetxController
    with LoadingManager, UIErrorManager
    implements MenuPresenter {
  final NavigateTo navigateTo;
  final CommandInformations commandInformations;
  final SearchProductByCode searchProductByCode;
  final LoadExpansibleGroups loadExpansibleGroups;
  final BarcodeScanner barcodeScanner;
  final LoadProducts loadProducts;
  final GetProductComposition getProductComposition;
  final LoadSuggestionSale loadSuggestionSale;
  final ManageProductSchedule manageProductSchedule;
  final ManageExpansibleGroupSchedule manageExpansibleGroupSchedule;
  final ParametersData parametersData;
  final LoadImages loadImages;
  final MenuDatabaseManagement menuDatabaseManagement;
  final InsertExportLoadType insertExportLoadType;
  final LastImport lastImport;

  GetxMenuPresenter({
    required this.loadExpansibleGroups,
    required this.navigateTo,
    required this.commandInformations,
    required this.searchProductByCode,
    required this.barcodeScanner,
    required this.loadProducts,
    required this.getProductComposition,
    required this.loadSuggestionSale,
    required this.manageProductSchedule,
    required this.manageExpansibleGroupSchedule,
    required this.parametersData,
    required this.loadImages,
    required this.menuDatabaseManagement,
    required this.insertExportLoadType,
    required this.lastImport,
  });

  @override
  void clear() {
    _loadedMenu.clear();
    searchedProduct = null;
  }

  @override
  Future<void> searchProduct(String value) async {
    searchedProduct = null;
    isLoading = true;
    mainError = null;

    if (value.toString().length <= 6) {
      value = _formatPlu(value);
    }

    try {
      final product = await searchProductByCode.search(
        url: EnterpriseBuilder.entity!.url!,
        enterpriseId: EnterpriseBuilder.entity!.enterpriseId!,
        value: value,
      );

      if (product != null) {
        searchedProduct = ProductsViewModel.fromEntity(product);
      }
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.productNotFound:
          mainError = UIError.productNotFound;
        default:
          mainError = UIError.unexpected;
      }
    } finally {
      isLoading = false;
    }
  }

  String _formatPlu(String number) {
    // Adiciona zeros à esquerda para garantir que tenha pelo menos 6 dígitos
    String paddedNumber = number.padLeft(6, '0');

    // Separa os primeiros 5 dígitos e o último dígito
    String firstPart = paddedNumber.substring(0, 5);
    String lastPart = paddedNumber.substring(5);
    final plu = '$firstPart-$lastPart';

    // Retorna a variável formatada
    return plu;
  }

  @override
  Future<String> readBarcodeAndSearchProduct() async {
    mainError = null;
    isLoading = true;

    String loadedBarcode = "";
    try {
      loadedBarcode = await barcodeScanner.read();

      if (loadedBarcode.isNotEmpty) {
        await searchProduct(loadedBarcode);
      }

      return loadedBarcode;
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.productNotFound:
          mainError = UIError.productNotFound;
        case DomainError.barcodeNotRead:
          mainError = UIError.barcodeNotRead;
        default:
          mainError = UIError.unexpected;
      }
      return loadedBarcode;
    } finally {
      isLoading = false;
    }
  }

  final List<LoadedMenuViewModel> _loadedMenu = [];
  @override
  List<LoadedMenuViewModel> get loadedMenu => [..._loadedMenu];

  final _inexOfSelectedGroup = Rx<int>(0);
  @override
  Stream<int> get indexOfSelectedGroupStream => _inexOfSelectedGroup.stream;
  set indexOfSelectedGroup(int value) => _inexOfSelectedGroup.value = value;

  List<ExpansibleGroupEntity> _putExpansibleGroupInFirst(
    List<ExpansibleGroupEntity> expansibleGroups,
    String expansibleGroupName,
  ) {
    ExpansibleGroupEntity? detachGroup = expansibleGroups.firstWhereOrNull(
        (e) =>
            e.Name.toLowerCase().contains(expansibleGroupName.toLowerCase()));

    if (detachGroup == null) {
      return expansibleGroups;
    } else {
      expansibleGroups.remove(detachGroup);
      return [detachGroup, ...expansibleGroups];
    }
  }

  @override
  Future<void> getGroupsAndProducts({
    required CommandEntity? commandEntity,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
    required bool loadLocally,
  }) async {
    try {
      bool menuIsNotEmpty = _loadedMenu
          .where((e) =>
              e.expansibleGroupsViewModel.Name !=
              R.string.searchProduct.toUpperCase())
          .isNotEmpty;

      if (loadLocally && menuIsNotEmpty) return;

      isLoading = true;

      if (loadLocally) {
        final localMenu = await menuDatabaseManagement.load();
        _loadedMenu.clear();
        _loadedMenu.addAll(localMenu);
        await treatShowSearchProducts();
        return;
      }

      await commandInformations.ticketIsPermitted(
        url: EnterpriseBuilder.entity!.url!,
        commandNumber: commandEntity?.commandNumber ?? "001",
      );

      clear();
      var expansibleGroups = await loadExpansibleGroups.load();

      if (expansibleGroups != null) {
        expansibleGroups = _putExpansibleGroupInFirst(
          expansibleGroups,
          R.string.promotionWithoutPoints,
        );
        expansibleGroups = _putExpansibleGroupInFirst(
          expansibleGroups,
          R.string.detach,
        );

        for (var expansibleGroup in expansibleGroups) {
          final products =
              await loadProducts.load(expansibleGroup.ExpansibleGroupId);

          if (products != null) {
            _addOrUpdateGroupAndProducts(products, expansibleGroup);
          } else {
            throw DomainError.unexpected;
          }
        }
      }

      final allProducts = _loadedMenu
          .expand((map) => map
              .productsViewModel) // Expande todas as listas de produtos em um Iterable
          .toList();

      for (var product in allProducts) {
        if (product.IsPromoCombox == "true") {
          final fathers = await getProductComposition.getFathers(
            internalCodeOnErp: product.InternalCodeOnERP!.toInt(),
          );

          final childs = await getProductComposition.getChildsOfFather(
            internalCodeOnErp: product.InternalCodeOnERP!.toInt(),
            fathers: fathers,
          );

          if (ProductCompositionEntity.listEquals(fathers, childs)) {
            product.childsComposition = [
              ProductCompositionViewModel(
                ProductCompositionId:
                    childs[0].ProductCompositionId?.toString(),
                EnterpriseId: childs[0].EnterpriseId?.toString(),
                InternalCodeOnERPCodeFather: product.InternalCodeOnERP,
                InternalCodeOnERPCodeChild: product.InternalCodeOnERP,
                PluChild: product.PriceLookupCode,
                ChildName: product.Name,
                Quantity: "1",
                SalePrice: product.SaleRetailPraticed,
                OfferPrice: product.OfferRetailPrice,
                Schedule: product.Schedule,
                IncrementValue: childs[0].IncrementValue?.toString(),
                IsOptionalItem: childs[0].IsOptionalItem?.toString(),
                ProductOptions: "",
                childs: [
                  ...childs
                      .map((e) => ProductCompositionViewModel.fromEntity(e))
                ],
              )
            ];
          } else {
            product.childsComposition = childs
                .map((e) => ProductCompositionViewModel.fromEntity(e))
                .toList();
          }
        }
      }

      // _loadedMenu.add({
      //   ExpansibleGroupsViewModel(
      //     Name: R.string.avaliate,
      //     ExpansibleGroupId: "0",
      //     ExpansibleGroupType: "0",
      //     OrderClassification: "0",
      //   ): []
      // });
      await expansibleGroupFromProductPresenter
          .loadCommentsAndObligatoryOptions(allProducts);

      final suggestions = await loadSuggestionSale.load();

      _updateSuggestions(suggestions);

      await treatShowSearchProducts();

      await menuDatabaseManagement.save(_loadedMenu);
      await lastImport.save([LoadTypeEnum.products]);

      if (_inexOfSelectedGroup.value >=
          treatSchedules<ExpansibleGroupsViewModel>().length) {
        _inexOfSelectedGroup.value =
            treatSchedules<ExpansibleGroupsViewModel>().length - 1;
      }
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.commandNotAvailable:
          throw DomainError.commandNotAvailable;
        default:
          throw DomainError.unexpected;
      }
    } finally {
      isLoading = false;
    }
  }

  void _addOrUpdateGroupAndProducts(
    List<ProductEntity>? products,
    ExpansibleGroupEntity expansibleGroup,
  ) {
    final groupName = getExpansibleGroupNameWithoutPipes(expansibleGroup.Name);
    final expansibleGroupViewModel = ExpansibleGroupsViewModel.fromEntity(
      entity: expansibleGroup,
      groupName: groupName,
      subgroupName: getSubgroup(expansibleGroup),
    );

    final productsViewModel = products!
        .map((e) => ProductsViewModel.fromEntity(
              e,
              subgroupName: getSubgroup(expansibleGroup),
            ))
        .toList();

    if (getAlreadyContainsExpansibleGroupName(groupName)) {
      int indexOfSameGroup = _loadedMenu
          .indexWhere((e) => e.expansibleGroupsViewModel.Name == groupName);

      if (indexOfSameGroup != -1) {
        _loadedMenu[indexOfSameGroup]
            .expansibleGroupsViewModel
            .subgroups
            .add(getSubgroup(expansibleGroup));
        _loadedMenu[indexOfSameGroup]
            .productsViewModel
            .addAll(productsViewModel);
      }
    } else {
      _loadedMenu.add(
        LoadedMenuViewModel(
          expansibleGroupsViewModel: expansibleGroupViewModel,
          productsViewModel: productsViewModel,
        ),
      );
    }
  }

  void _updateSuggestions(List<SuggestionSaleEntity> suggestions) {
    for (var suggestion in suggestions) {
      for (var menu in _loadedMenu) {
        int indexOfProduct = menu.productsViewModel.indexWhere((e) =>
            e.InternalCodeOnERP == suggestion.ProductPackingCode.toString());

        if (indexOfProduct != -1) {
          if (menu.productsViewModel[indexOfProduct].suggestions == null) {
            menu.productsViewModel[indexOfProduct].suggestions = [];
          }
          menu.productsViewModel[indexOfProduct].suggestions!.add(suggestion);
        }
      }
    }
  }

  @override
  void updateIndexOfSelectedGroup(int index) {
    _inexOfSelectedGroup.value = index;
    doScroll = true;
  }

  @override
  void updateSuggestionsProducts(ProductsViewModel selectedProduct) {
    _suggestionsProductsViewModel.clear();
    _indexOfAtualSuggestion = -1;

    bool verifySuggestions = selectedProduct.suggestions?.isNotEmpty == true &&
        (_indexOfAtualSuggestion + 1) < selectedProduct.suggestions!.length;

    if (verifySuggestions) {
      final allProducts =
          _loadedMenu.expand((map) => map.productsViewModel).toList();

      for (var suggestion in selectedProduct.suggestions!) {
        final suggestionProduct = allProducts.firstWhereOrNull((e) =>
            e.InternalCodeOnERP ==
            suggestion.ProductPackingCodeSuggestionForSale.toString());

        if (suggestionProduct == null) {
          continue;
        }

        if (!_suggestionsProductsViewModel.contains(suggestionProduct)) {
          _suggestionsProductsViewModel.add(suggestionProduct);
        }
      }
    }
  }

  @override
  void advanceIndexOfAtualSuggestion() {
    if (_indexOfAtualSuggestion + 1 < _suggestionsProductsViewModel.length) {
      _indexOfAtualSuggestion = _indexOfAtualSuggestion + 1;
      atualSuggestionProduct =
          _suggestionsProductsViewModel[_indexOfAtualSuggestion];
    }
  }

  @override
  void goToInsertProductPage(ProductsViewModel product) {
    navigateTo.navigate(
      pageRoute: PageRoutes.insertProducts,
      arguments: product,
    );
  }

  @override
  String getExpansibleGroupNameWithoutPipes(String expansibleGroupName) {
    RegExp regex = RegExp(r'^.*?(?=\|)');
    Match? match = regex.firstMatch(expansibleGroupName);

    if (match != null) {
      return match.group(0)!;
    } else {
      return expansibleGroupName;
    }
  }

  @override
  bool getAlreadyContainsExpansibleGroupName(String expansibleGroupName) {
    for (var item in _loadedMenu) {
      if (item.expansibleGroupsViewModel.Name ==
          getExpansibleGroupNameWithoutPipes(expansibleGroupName)) {
        return true;
      }
    }

    return false;
  }

  @override
  String? getSubgroup(ExpansibleGroupEntity expansibleGroupEntity) {
    RegExp regExp = RegExp(r'^[^|]*\|(.+)');
    Match? match = regExp.firstMatch(expansibleGroupEntity.Name);

    if (match != null) {
      return match.group(1)!;
    } else {
      return null;
    }
  }

  final _searchedProduct = Rx<ProductsViewModel?>(null);
  @override
  Stream<ProductsViewModel?> get searchedProductStream =>
      _searchedProduct.stream;
  set searchedProduct(ProductsViewModel? value) =>
      _searchedProduct.value = value;

  final _doScrollGroupsStream = false.obs;
  @override
  Stream<bool> get doScrollGroupsStream => _doScrollGroupsStream.stream;
  set doScroll(bool _) {
    // Future.delayed(const Duration(milliseconds: 50), () {
    //   _doScrollStream.subject.add(false);
    // });
    Future.delayed(const Duration(milliseconds: 50), () {
      _doScrollGroupsStream.subject.add(true);
    });
  }

  int _indexOfAtualSuggestion = -1;
  @override
  int get indexOfAtualSuggestion => _indexOfAtualSuggestion;

  final List<ProductsViewModel> _suggestionsProductsViewModel = [];
  @override
  List<ProductsViewModel> get suggestionsProductsViewModel =>
      _suggestionsProductsViewModel;

  final _atualSuggestionProduct = Rx<ProductsViewModel?>(null);
  @override
  Stream<ProductsViewModel?> get atualSuggestionProductStream =>
      _atualSuggestionProduct.stream;
  set atualSuggestionProduct(ProductsViewModel? product) =>
      _atualSuggestionProduct.subject.add(product);

  @override
  Future<bool> insertUpdateProductSchedule({
    required int internalCodeOnErp,
    required int expansibleGroupId,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
    required HomePresenter homePresenter,
  }) async {
    isLoading = true;
    mainError = null;
    try {
      if (_productSchedule.value?.AllowMonday == true &&
          _productSchedule.value?.AllowTuesday == true &&
          _productSchedule.value?.AllowWednesday == true &&
          _productSchedule.value?.AllowThursday == true &&
          _productSchedule.value?.AllowFriday == true &&
          _productSchedule.value?.AllowSaturday == true &&
          _productSchedule.value?.AllowSunday == true) {
        await manageProductSchedule.delete(internalCodeOnErp);
      } else {
        await manageProductSchedule
            .insertUpdate(_productSchedule.value!.toEntity());
      }

      await insertExportLoadType.insert("schedule");

      await getGroupsAndProducts(
        commandEntity: homePresenter.commandEntity,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        loadLocally: true,
      );
      return true;
    } catch (e) {
      mainError = UIError.unexpected;
      return false;
    } finally {
      isLoading = false;
    }
  }

  final _productSchedule = Rx<ProductScheduleViewModel?>(null);
  @override
  Stream<ProductScheduleViewModel?> get productScheduleStream =>
      _productSchedule.stream;
  set atualProductSchedule(ProductScheduleViewModel? value) =>
      _productSchedule.value = value;

  @override
  void updateProductScheduleStream({
    required int internalCodeOnErp,
    bool? monday,
    bool? tuesday,
    bool? wednesday,
    bool? thursday,
    bool? friday,
    bool? saturday,
    bool? sunday,
  }) {
    final schedule = ProductScheduleViewModel(
      InternalCodeOnERP: internalCodeOnErp,
      EnterpriseId: EnterpriseBuilder.entity!.enterpriseId!,
      AllowMonday: monday ?? _productSchedule.value?.AllowMonday == true,
      AllowTuesday: tuesday ?? _productSchedule.value?.AllowTuesday == true,
      AllowWednesday:
          wednesday ?? _productSchedule.value?.AllowWednesday == true,
      AllowThursday: thursday ?? _productSchedule.value?.AllowThursday == true,
      AllowFriday: friday ?? _productSchedule.value?.AllowFriday == true,
      AllowSaturday: saturday ?? _productSchedule.value?.AllowSaturday == true,
      AllowSunday: sunday ?? _productSchedule.value?.AllowSunday == true,
    );

    atualProductSchedule = null;
    atualProductSchedule = schedule;
  }

  @override
  List<T> treatSchedules<T>() {
    Map<int, String> daysOfWeek = {
      1: 'Monday',
      2: 'Tuesday',
      3: 'Wednesday',
      4: 'Thursday',
      5: 'Friday',
      6: 'Saturday',
      7: 'Sunday',
    };
    DateTime now = DateTime.now();
    String dayOfWeek = daysOfWeek[now.weekday]!;

    if (T == ProductsViewModel) {
      List<ExpansibleGroupsViewModel> treatedGroups =
          treatSchedules<ExpansibleGroupsViewModel>();

      List<LoadedMenuViewModel> filteredMenu = [];
      // Percorre a lista loadedMenu
      for (var menuItem in loadedMenu) {
        // Para cada mapa em loadedMenu, verifica se a chave está em 'groups'
        if (treatedGroups.contains(menuItem.expansibleGroupsViewModel)) {
          // Se encontrar correspondência, adiciona o item na nova lista
          filteredMenu.add(menuItem);
        }
      }

      return filteredMenu.isEmpty
          ? []
          : filteredMenu[_inexOfSelectedGroup.value]
              .productsViewModel
              .where((e) {
              if (e.Schedule == null) {
                return true;
              } else if (dayOfWeek == daysOfWeek[1]) {
                return e.Schedule!.AllowMonday == true;
              } else if (dayOfWeek == daysOfWeek[2]) {
                return e.Schedule!.AllowTuesday == true;
              } else if (dayOfWeek == daysOfWeek[3]) {
                return e.Schedule!.AllowWednesday == true;
              } else if (dayOfWeek == daysOfWeek[4]) {
                return e.Schedule!.AllowThursday == true;
              } else if (dayOfWeek == daysOfWeek[5]) {
                return e.Schedule!.AllowFriday == true;
              } else if (dayOfWeek == daysOfWeek[6]) {
                return e.Schedule!.AllowSaturday == true;
              } else if (dayOfWeek == daysOfWeek[7]) {
                return e.Schedule!.AllowSunday == true;
              } else {
                return true;
              }
            }).toList() as List<T>;
    } else if (T == ExpansibleGroupsViewModel) {
      return loadedMenu.map((x) => x.expansibleGroupsViewModel).where((e) {
        if (e.Schedule == null) {
          return true;
        } else if (dayOfWeek == daysOfWeek[1]) {
          return e.Schedule!.AllowMonday == true;
        } else if (dayOfWeek == daysOfWeek[2]) {
          return e.Schedule!.AllowTuesday == true;
        } else if (dayOfWeek == daysOfWeek[3]) {
          return e.Schedule!.AllowWednesday == true;
        } else if (dayOfWeek == daysOfWeek[4]) {
          return e.Schedule!.AllowThursday == true;
        } else if (dayOfWeek == daysOfWeek[5]) {
          return e.Schedule!.AllowFriday == true;
        } else if (dayOfWeek == daysOfWeek[6]) {
          return e.Schedule!.AllowSaturday == true;
        } else if (dayOfWeek == daysOfWeek[7]) {
          return e.Schedule!.AllowSunday == true;
        } else {
          return true;
        }
      }).toList() as List<T>;
    }

    return [];
  }

  final _expansibleGroupSchedule = Rx<ExpansibleGroupScheduleViewModel?>(null);
  @override
  Stream<ExpansibleGroupScheduleViewModel?> get expansibleGroupScheduleStream =>
      _expansibleGroupSchedule.stream;
  set expansibleGroupSchedule(ExpansibleGroupScheduleViewModel? value) =>
      _expansibleGroupSchedule.value = value;

  @override
  Future<bool> insertUpdateExpansibleGroupSchedule(
    int expansibleGroupId,
  ) async {
    isLoading = true;
    mainError = null;
    try {
      if (_expansibleGroupSchedule.value?.AllowMonday == true &&
          _expansibleGroupSchedule.value?.AllowTuesday == true &&
          _expansibleGroupSchedule.value?.AllowWednesday == true &&
          _expansibleGroupSchedule.value?.AllowThursday == true &&
          _expansibleGroupSchedule.value?.AllowFriday == true &&
          _expansibleGroupSchedule.value?.AllowSaturday == true &&
          _expansibleGroupSchedule.value?.AllowSunday == true) {
        await manageExpansibleGroupSchedule.delete(expansibleGroupId);
      } else {
        await manageExpansibleGroupSchedule
            .insertUpdate(_expansibleGroupSchedule.value!.toEntity());
      }

      final index = _loadedMenu.indexWhere((e) =>
          e.expansibleGroupsViewModel.ExpansibleGroupId.toInt() ==
          expansibleGroupId);
      final oldGroup = _loadedMenu[index].expansibleGroupsViewModel;
      final groupUpdated = ExpansibleGroupsViewModel(
        Name: oldGroup.Name,
        ExpansibleGroupId: oldGroup.ExpansibleGroupId,
        ExpansibleGroupType: oldGroup.ExpansibleGroupType,
        OrderClassification: oldGroup.OrderClassification,
        subgroups: oldGroup.subgroups,
        Schedule: ExpansibleGroupScheduleModel.fromEntity(
            _expansibleGroupSchedule.value!.toEntity()),
      );
      final oldProducts = _loadedMenu[index].productsViewModel;
      _loadedMenu[index] = LoadedMenuViewModel(
        expansibleGroupsViewModel: groupUpdated,
        productsViewModel: oldProducts,
      );

      await insertExportLoadType.insert("schedule");

      return true;
    } catch (e) {
      mainError = UIError.unexpected;
      return false;
    } finally {
      isLoading = false;
    }
  }

  @override
  void updateExpansibleGroupScheduleStream({
    required int expansibleGroupId,
    bool? monday,
    bool? tuesday,
    bool? wednesday,
    bool? thursday,
    bool? friday,
    bool? saturday,
    bool? sunday,
  }) {
    final schedule = ExpansibleGroupScheduleViewModel(
      ExpansibleGroupId: expansibleGroupId,
      AllowMonday:
          monday ?? _expansibleGroupSchedule.value?.AllowMonday == true,
      AllowTuesday:
          tuesday ?? _expansibleGroupSchedule.value?.AllowTuesday == true,
      AllowWednesday:
          wednesday ?? _expansibleGroupSchedule.value?.AllowWednesday == true,
      AllowThursday:
          thursday ?? _expansibleGroupSchedule.value?.AllowThursday == true,
      AllowFriday:
          friday ?? _expansibleGroupSchedule.value?.AllowFriday == true,
      AllowSaturday:
          saturday ?? _expansibleGroupSchedule.value?.AllowSaturday == true,
      AllowSunday:
          sunday ?? _expansibleGroupSchedule.value?.AllowSunday == true,
    );

    expansibleGroupSchedule = null;
    expansibleGroupSchedule = schedule;
  }

  @override
  Future<void> treatShowSearchProducts() async {
    try {
      final parameters = await parametersData.load();

      final searchProductsEnabled = parameters.firstWhereOrNull(
              (e) => e.key == ParameterKey.enableSearchProducts && e.enabled) !=
          null;

      final isDisabled = _loadedMenu
          .where((e) =>
              e.expansibleGroupsViewModel.Name ==
              R.string.searchProduct.toUpperCase())
          .isEmpty;

      if (searchProductsEnabled && isDisabled) {
        int index = 0;
        if (_loadedMenu.isNotEmpty &&
            _loadedMenu[0].expansibleGroupsViewModel.Name.toUpperCase() ==
                R.string.detach.toUpperCase()) {
          index = 1;
        }

        _loadedMenu.insert(
            index,
            LoadedMenuViewModel(
              expansibleGroupsViewModel: ExpansibleGroupsViewModel(
                Name: R.string.searchProduct.toUpperCase(),
                ExpansibleGroupId: "0",
                ExpansibleGroupType: "0",
                OrderClassification: "0",
                Schedule: null,
                subgroups: [],
              ),
              productsViewModel: [],
            ));
      } else if (!searchProductsEnabled) {
        int index = _loadedMenu.indexWhere((e) =>
            e.expansibleGroupsViewModel.Name.toUpperCase() ==
            R.string.searchProduct.toUpperCase());

        if (index != -1) {
          _loadedMenu.removeAt(index);
        }
      }
    } catch (e) {
      e;
    }
  }

  @override
  Future<void> loadAllImages({
    required bool loadLocally,
    required List<String> updatedImages,
  }) async {
    try {
      if (loadLocally && _downloadedImages.isNotEmpty) return;

      _downloadedImages = await loadImages.load(
        getLocalImages: loadLocally,
        updatedImages: updatedImages,
      );

      await lastImport.save([LoadTypeEnum.images]);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  List<ImageModel> _downloadedImages = [];
  @override
  List<ImageModel> get downloadedImages => [..._downloadedImages];
}
