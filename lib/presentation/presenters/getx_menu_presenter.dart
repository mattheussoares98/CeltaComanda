import 'package:clean_celta_mobile/presentation/mixins/mixins.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';

import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../main/builders/builders.dart';
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

  GetxMenuPresenter({
    required this.loadExpansibleGroups,
    required this.navigateTo,
    required this.ticketIsPermitted,
    required this.searchProductByCode,
    required this.barcodeScanner,
    required this.updateSaleRequestTemp,
    required this.loadProducts,
  });

  @override
  void goToProductsPage(ExpansibleGroupEntity entity) {
    navigateTo.navigate(
      pageRoute: PageRoutes.products,
      arguments: entity,
    );
  }

  @override
  void goToComboxPage(ProductsViewModel product) {
    navigateTo.navigate(
      pageRoute: PageRoutes.productComposition,
      arguments: product,
    );
  }

  @override
  void clear() {
    _menu.value = [];
    _loadedMenu.clear();
    _selectedProduct.value = null;
  }

  @override
  Future<void> searchProduct(String value) async {
    _selectedProduct.value = null;
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
        _selectedProduct.value = ProductsViewModel.fromEntity(product);
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
        default:
          mainError = UIError.unexpected;
      }
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> loadCommandData({
    required String commandNumber,
    required PrintedProductsPresenter printedProductsPresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
    required MenuPresenter menuPresenter,
    required HomePresenter homePresenter,
  }) async {
    isLoading = true;
    mainError = null;
    homePresenter.updateCommandNumber(commandNumber);
    clear();
    printedProductsPresenter.clear();
    saleRequestTempPresenter.clear();

    try {
      await getGroupsAndProducts(commandNumber);
      await saleRequestTempPresenter.loadSaleRequest(commandNumber);
      await printedProductsPresenter.loadPrinted(commandNumber);
    } on DomainError catch (error) {
      homePresenter.updateCommandNumber(null);
      switch (error) {
        case DomainError.commandNotAvailable:
          mainError = UIError.commandNotAvailable;
          break;
        default:
          mainError = UIError.unexpected;
      }
    } finally {
      isLoading = false;
    }
  }

  final _selectedProduct = Rx<ProductsViewModel?>(null);
  @override
  Stream<ProductsViewModel?> get selectedProductStream =>
      _selectedProduct.stream;
  set selectedProduct(ProductsViewModel? value) =>
      _selectedProduct.value = value;

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

  @override
  Future<void> getGroupsAndProducts(String commandNumber) async {
    isLoading = true;
    mainError = null;
    clear();

    try {
      await ticketIsPermitted.verify(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        commandNumber: commandNumber,
      );

      final expansibleGroups = await loadExpansibleGroups.load();

      if (expansibleGroups != null) {
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
      _menu.subject.add(_loadedMenu);
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.commandNotAvailable:
          mainError = UIError.commandNotAvailable;
        default:
          mainError = UIError.unexpected;
      }
    } finally {
      isLoading = false;
    }
  }

  @override
  void updateIndexOfSelectedGroup(int index) {
    _inexOfSelectedGroup.value = index;
    _selectedProduct.value = null;
  }

  @override
  void updateSelectedProduct(ProductsViewModel? selectedProduct) {
    _selectedProduct.value = selectedProduct;
  }
}
