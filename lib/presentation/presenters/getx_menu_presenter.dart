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
  final TicketIsPermitted ticketIsPermitted;
  final SearchProductByCode searchProductByCode;
  final LoadExpansibleGroups loadExpansibleGroups;
  final BarcodeScanner barcodeScanner;
  final UpdateSaleRequestTemp updateSaleRequestTemp;
  final LoadProducts loadProducts;
  final GetProductComposition getProductComposition;

  GetxMenuPresenter({
    required this.loadExpansibleGroups,
    required this.navigateTo,
    required this.ticketIsPermitted,
    required this.searchProductByCode,
    required this.barcodeScanner,
    required this.updateSaleRequestTemp,
    required this.loadProducts,
    required this.getProductComposition,
  });

  @override
  void goToProductsPage(ExpansibleGroupEntity entity) {
    navigateTo.navigate(
      pageRoute: PageRoutes.products,
      arguments: entity,
    );
  }

  @override
  Future<void> goToComboxPage(ProductsViewModel product) async {
    await navigateTo.navigate(
      pageRoute: PageRoutes.productComposition,
      arguments: product,
    );
  }

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
        (e) => e.Name.toLowerCase() == "DESTAQUES".toLowerCase());

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
    required CommentsPresenter commentsPresenter,
  }) async {
    isLoading = true;
    mainError = null;
    _inexOfSelectedGroup.value = 0;
    clear();

    try {
      await ticketIsPermitted.verify(
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

          product.childsComposition = childs;
        }
      }

      _loadedMenu.add({
        const ExpansibleGroupsViewModel(
          Name: "Avaliar",
          ExpansibleGroupId: "0",
          ExpansibleGroupType: "0",
          OrderClassification: "0",
        ): []
      });
      await commentsPresenter.loadComments(allProducts);
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

  @override
  void updateIndexOfSelectedGroup(int index) {
    _inexOfSelectedGroup.value = index;
    doScroll = true;
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
      pageRoute: PageRoutes.productComposition,
      arguments: product,
    );
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
}
