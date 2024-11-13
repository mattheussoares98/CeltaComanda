import 'dart:async';

import 'package:get/get.dart';

import 'package:flutter/material.dart';

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
  });

  @override
  void clear() {
    _menu.subject.add([]);
    _loadedMenu.clear();
    _searchedProduct = null;
  }

  @override
  Future<void> searchProduct(String value) async {
    _searchedProduct = null;
    isLoading = true;
    mainError = null;

    if (value.toString().length <= 6) {
      value = _formatPlu(value);
    }

    try {
      final product = await searchProductByCode.search(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        value: value,
      );

      if (product != null) {
        _searchedProduct = ProductsViewModel.fromEntity(product);
        searchProductController.clear();
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
  Future<void> readBarcodeAndSearchProduct() async {
    mainError = null;
    isLoading = true;
    searchProductController.text = "";

    try {
      searchProductController.text = await barcodeScanner.read();

      if (searchProductController.text.isNotEmpty) {
        await searchProduct(searchProductController.text);
      }
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.productNotFound:
          mainError = UIError.productNotFound;
        case DomainError.barcodeNotRead:
          mainError = UIError.barcodeNotRead;
        default:
          mainError = UIError.unexpected;
      }
    } finally {
      isLoading = false;
    }
  }

  final List<Map<ExpansibleGroupsViewModel, List<ProductsViewModel>>>
      _loadedMenu = [];
  @override
  List<Map<ExpansibleGroupsViewModel, List<ProductsViewModel>>>
      get loadedMenu => [..._loadedMenu];

  final _searchProductController = TextEditingController();
  @override
  TextEditingController get searchProductController => _searchProductController;

  final _inexOfSelectedGroup = Rx<int>(0);
  @override
  Stream<int> get indexOfSelectedGroupStream => _inexOfSelectedGroup.stream;
  set indexOfSelectedGroup(int value) => _inexOfSelectedGroup.value = value;

  final _menu =
      Rx<List<Map<ExpansibleGroupsViewModel, List<ProductsViewModel>>>>([]);
  @override
  Stream<List<Map<ExpansibleGroupsViewModel, List<ProductsViewModel>>>>
      get menuStream => _menu.stream;
  set menu(
          List<Map<ExpansibleGroupsViewModel, List<ProductsViewModel>>>
              value) =>
      _menu.value = value;

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
    required String commandNumber,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
  }) async {
    isLoading = true;
    mainError = null;
    _inexOfSelectedGroup.value = 0;
    clear();

    try {
      await commandInformations.ticketIsPermitted(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        commandNumber: commandNumber,
      );

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
          .expand((map) =>
              map.values) // Expande todas as listas de produtos em um Iterable
          .expand((lista) =>
              lista) // Expande cada lista individual de produtos em um Iterable
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

      _menu.subject.add(_loadedMenu);
      _showPreLoadImages.subject.add(true);
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.commandNotAvailable:
          throw DomainError.commandNotAvailable;
        default:
          throw DomainError.unexpected;
      }
    } finally {
      isLoading = false;
      Future.delayed(const Duration(seconds: 10), () {
        showPreLoadImage = false;
      });
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
      int indexOfSameGroup =
          _loadedMenu.indexWhere((e) => e.keys.first.Name == groupName);

      if (indexOfSameGroup != -1) {
        _loadedMenu[indexOfSameGroup]
            .keys
            .first
            .subgroups
            .add(getSubgroup(expansibleGroup));
        _loadedMenu[indexOfSameGroup].values.first.addAll(productsViewModel);
      }
    } else {
      _loadedMenu.add({expansibleGroupViewModel: productsViewModel});
    }
  }

  void _updateSuggestions(List<SuggestionSaleEntity> suggestions) {
    for (var suggestion in suggestions) {
      for (var menu in _loadedMenu) {
        for (var products in menu.values) {
          int indexOfProduct = products.indexWhere((e) =>
              e.InternalCodeOnERP == suggestion.ProductPackingCode.toString());

          if (indexOfProduct != -1) {
            if (products[indexOfProduct].suggestions == null) {
              products[indexOfProduct].suggestions = [];
            }
            products[indexOfProduct].suggestions!.add(suggestion);
          }
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

    if (selectedProduct.suggestions?.isNotEmpty == true &&
        (_indexOfAtualSuggestion + 1) < selectedProduct.suggestions!.length) {
      for (var suggestion in selectedProduct.suggestions!) {
        for (var menu in _loadedMenu) {
          for (var products in menu.values) {
            int indexOfProduct = products.indexWhere((e) =>
                e.InternalCodeOnERP ==
                suggestion.ProductPackingCodeSuggestionForSale.toString());

            if (indexOfProduct != -1) {
              if (!_suggestionsProductsViewModel
                  .contains(products[indexOfProduct])) {
                _suggestionsProductsViewModel.add(products[indexOfProduct]);
              }
            }
          }
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
      for (var group in item.keys) {
        if (group.Name ==
            getExpansibleGroupNameWithoutPipes(expansibleGroupName)) {
          return true;
        }
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

  ProductsViewModel? _searchedProduct;
  @override
  ProductsViewModel? get searchedProduct => _searchedProduct;

  final _showPreLoadImages = false.obs;
  @override
  Stream<bool> get showPreLoadImagesStream => _showPreLoadImages.stream;
  set showPreLoadImage(bool value) => _showPreLoadImages.subject.add(value);

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
  Future<bool> insertUpdateProductSchedule(
    int internalCodeOnErp,
  ) async {
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
  void updateProductSchedule({
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
      EnterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
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
      return loadedMenu[_inexOfSelectedGroup.value].values.first.where((e) {
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
      return loadedMenu.expand((map) => map.keys).toList().where((e) {
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
      return true;
    } catch (e) {
      mainError = UIError.unexpected;
      return false;
    } finally {
      isLoading = false;
    }
  }

  @override
  void updateExpansibleGroupSchedule({
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
}
