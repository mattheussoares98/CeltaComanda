import 'package:get/get.dart';

import 'package:flutter/material.dart';

import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxExpansibleGroupsPresenter
    with ChangeNotifier
    implements ExpansibleGroupsPresenter {
  final NavigateTo navigateTo;
  final TicketIsPermitted ticketIsPermitted;
  final SearchProductByCode searchProductByCode;
  final LoadExpansibleGroups loadExpansibleGroups;
  final BarcodeScanner barcodeScanner;
  final UpdateSaleRequestTemp updateSaleRequestTemp;
  final LoadProducts loadProducts;

  GetxExpansibleGroupsPresenter({
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
    _expansibleGroups.clear();
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
        notifyListeners();
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
  Future<void> updateSaleRequest({
    required List<UpdateSaleRequestTempProductEntity> products,
    required HomePresenter homePresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
  }) async {
    isLoading = true;
    mainError = null;
    try {
      final entity = UpdateSaleRequestTempEntity(
        DeliveryControl:
            saleRequestTempPresenter.saleRequestTemp!.DeliveryControl.toInt(),
        EnterpriseId:
            saleRequestTempPresenter.saleRequestTemp!.EnterpriseId.toInt(),
        PersonalizedCode:
            saleRequestTempPresenter.saleRequestTemp!.PersonalizedCode,
        SaleRequestTempId:
            saleRequestTempPresenter.saleRequestTemp!.SaleRequestTempId.toInt(),
        TotalLiquid: products[0].Quantity *
            searchedProduct!.SaleRetailPraticed.toDouble(),
        Products: products,
      );

      await updateSaleRequestTemp.update(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        entity: entity,
      );

      await saleRequestTempPresenter
          .loadSaleRequest(homePresenter.commandNumber!);
    } on DomainError catch (e) {
      switch (e) {
        case DomainError.addComment:
          mainError = UIError.addComment;
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
  Future<void> loadCommandData({
    required String commandNumber,
    required PrintedProductsPresenter printedProductsPresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
    required ExpansibleGroupsPresenter expansibleGroupsPresenter,
    required HomePresenter homePresenter,
  }) async {
    isLoading = true;
    mainError = null;
    homePresenter.updateCommandNumber(commandNumber);
    clear();
    printedProductsPresenter.clear();
    saleRequestTempPresenter.clear();

    try {
      await getGroups(commandNumber);
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

  @override
  ProductsViewModel? get searchedProduct => _searchedProduct;
  ProductsViewModel? _searchedProduct;

  final List<Map<ExpansibleGroupsViewModel, List<ProductsViewModel>>>
      _expansibleGroups = [];
  @override
  List<Map<ExpansibleGroupsViewModel, List<ProductsViewModel>>>
      get expansibleGroups => [..._expansibleGroups];

  final _searchProductController = TextEditingController();
  @override
  TextEditingController get searchProductController => _searchProductController;

  final _isLoading = false.obs;
  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;
  set isLoading(bool value) => _isLoading.value = value;

  final _mainError = Rx<UIError?>(null);
  @override
  Stream<UIError?> get mainErrorStream => _mainError.stream;
  set mainError(UIError? value) => _mainError.value = value;

  final _inexOfSelectedGroup = Rx<int>(0);
  @override
  Stream<int> get indexOfSelectedGroupStream => _inexOfSelectedGroup.stream;
  set indexOfSelectedGroup(int value) => _inexOfSelectedGroup.value = value;

  @override
  Future<void> getGroups(String commandNumber) async {
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
            _expansibleGroups.add({
              ExpansibleGroupsViewModel.fromEntity(expansibleGroup):
                  products.map((e) => ProductsViewModel.fromEntity(e)).toList()
            });
          } else {
            throw DomainError.unexpected;
          }
        }
      }
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.commandNotAvailable:
          throw DomainError.commandNotAvailable;
        default:
          throw DomainError.unexpected;
      }
    } finally {
      notifyListeners();
    }
  }

  @override
  void updateIndexOfSelectedGroup(int index) {
    _inexOfSelectedGroup.value = index;
  }
}
