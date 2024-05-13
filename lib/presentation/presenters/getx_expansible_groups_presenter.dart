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

  GetxExpansibleGroupsPresenter({
    required this.loadExpansibleGroups,
    required this.navigateTo,
    required this.ticketIsPermitted,
    required this.searchProductByCode,
    required this.barcodeScanner,
    required this.updateSaleRequestTemp,
  });

  @override
  void goToProductsPage(ExpansibleGroupEntity entity) {
    navigateTo.navigate(
      pageRoute: PageRoutes.products,
      arguments: entity,
    );
  }

  @override
  Future<void> loadGroups(String commandNumber) async {
    clear();

    try {
      await ticketIsPermitted.verify(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        commandNumber: commandNumber,
      );

      final expansibleGroups = await loadExpansibleGroups.load();

      if (expansibleGroups != null) {
        _expansibleGroups.addAll(expansibleGroups
            .map((e) => ExpansibleGroupsViewModel.fromEntity(e))
            .toList());
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
    required ProductsViewModel productsViewModel,
    required HomePresenter homePresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
  }) async {
    isLoading = true;
    mainError = null;
    try {
      String numberAmerican =
          productsViewModel.SaleRetailPraticed.replaceAll(RegExp(r','), '.');

      double saleRetailPraticed = double.parse(numberAmerican);

      final entity = UpdateSaleRequestTempEntity(
        DeliveryControl: int.parse(
            saleRequestTempPresenter.saleRequestTemp!.DeliveryControl),
        EnterpriseId:
            int.parse(saleRequestTempPresenter.saleRequestTemp!.EnterpriseId),
        PersonalizedCode:
            saleRequestTempPresenter.saleRequestTemp!.PersonalizedCode,
        SaleRequestTempId: int.parse(
            saleRequestTempPresenter.saleRequestTemp!.SaleRequestTempId),
        TotalLiquid: saleRetailPraticed,
        Products: [
          UpdateSaleRequestTempProductEntity(
            ProductInternalCodeOnErp:
                int.parse(productsViewModel.InternalCodeOnERP.toString()),
            ProductPriceLookUpCode: productsViewModel.PriceLookupCode,
            Quantity: 1,
            SaleRequestTempId: int.parse(
                saleRequestTempPresenter.saleRequestTemp!.SaleRequestTempId),
            TotalLiquid: saleRetailPraticed,
            Value: saleRetailPraticed,
          )
        ],
      );

      await updateSaleRequestTemp.update(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        entity: entity,
      );

      await saleRequestTempPresenter.loadSaleRequest(homePresenter.commandNumber!);
    } on DomainError catch (e) {
      switch (e) {
        case DomainError.addComment:
          mainError = UIError.addComment;
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
      await loadGroups(commandNumber);
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

  final List<ExpansibleGroupsViewModel> _expansibleGroups = [];
  @override
  List<ExpansibleGroupsViewModel> get expansibleGroups =>
      [..._expansibleGroups];

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
}
