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

  GetxMenuPresenter({
    required this.loadExpansibleGroups,
    required this.navigateTo,
    required this.commandInformations,
    required this.searchProductByCode,
    required this.barcodeScanner,
    required this.loadProducts,
    required this.getProductComposition,
    required this.loadSuggestionSale,
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

  List<ExpansibleGroupEntity> _putDetachGroupInFirstGroupList(
    List<ExpansibleGroupEntity> expansibleGroups,
  ) {
    ExpansibleGroupEntity? detachGroup = expansibleGroups.firstWhereOrNull(
        (e) => e.Name.toLowerCase() == R.string.detach.toLowerCase());

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
        expansibleGroups = _putDetachGroupInFirstGroupList(expansibleGroups);

        for (var expansibleGroup in expansibleGroups) {
          final products =
              await loadProducts.load(expansibleGroup.ExpansibleGroupId);

          if (products != null) {
            _loadedMenu.add({
              ExpansibleGroupsViewModel.fromEntity(expansibleGroup):
                  products.map((e) => ProductsViewModel.fromEntity(e)).toList()
            });
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

          List<ProductCompositionViewModel> childs =
              await getProductComposition.getChildsOfFather(
            internalCodeOnErp: product.InternalCodeOnERP!.toInt(),
            fathers: fathers,
          );

          if (fathers.toString() ==
              childs.map((e) => e.toEntity()).toList().toString()) {
            product.childsComposition = [
              ProductCompositionViewModel(
                ProductCompositionId: childs[0].ProductCompositionId,
                EnterpriseId: childs[0].EnterpriseId,
                InternalCodeOnERPCodeFather: product.InternalCodeOnERP,
                InternalCodeOnERPCodeChild: product.InternalCodeOnERP,
                PluChild: product.PriceLookupCode,
                ChildName: product.Name,
                Quantity: "1",
                SalePrice: product.SaleRetailPraticed,
                OfferPrice: product.OfferRetailPrice,
                IncrementValue: childs[0].IncrementValue,
                IsOptionalItem: childs[0].IsOptionalItem,
                ProductOptions: "",
                childs: [...childs],
              )
            ];
          } else {
            product.childsComposition = childs;
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

      if (_indexOfAtualSuggestion != -1) {
        _suggestionsProductsViewModel
            .add(_suggestionsProductsViewModel[_indexOfAtualSuggestion]);
      }
      _indexOfAtualSuggestion = 0;
    }
  }

  @override
  void advanceIndexOfAtualSuggestion() {
    _indexOfAtualSuggestion = _indexOfAtualSuggestion + 1;
  }

  ProductsViewModel? _searchedProduct;
  @override
  ProductsViewModel? get searchedProduct => _searchedProduct;

  final _showPreLoadImages = false.obs;
  @override
  Stream<bool> get showPreLoadImagesStream => _showPreLoadImages.stream;
  set showPreLoadImage(bool value) => _showPreLoadImages.subject.add(value);

  @override
  void goToInsertProductPage(ProductsViewModel product) {
    navigateTo.navigate(
      pageRoute: PageRoutes.insertProducts,
      arguments: product,
    );
    _indexOfAtualSuggestion = -1;
  }

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
}
