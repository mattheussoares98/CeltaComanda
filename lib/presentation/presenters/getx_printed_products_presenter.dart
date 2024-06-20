import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxPrintedProductsPresenter
    with ChangeNotifier
    implements PrintedProductsPresenter {
  final UserValidations userValidations;
  final LoadPrintedProducts loadPrintedProducts;
  final RemovePrintedProduct removePrintedProduct;
  final TicketIsPermitted ticketIsPermitted;
  final BarcodeScanner barcodeScanner;

  GetxPrintedProductsPresenter({
    required this.userValidations,
    required this.loadPrintedProducts,
    required this.removePrintedProduct,
    required this.ticketIsPermitted,
    required this.barcodeScanner,
  });

  @override
  Future<void> removeProduct({
    required String saleRequestProductId,
    required MenuPresenter menuPresenter,
    required CartPresenter cartPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required HomePresenter homePresenter,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      await removePrintedProduct.remove(
        productId: saleRequestProductId,
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
      );

      await loadCommandData(
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
        clearPermissionToCancelProducts: false,
        isRemovingProduct: true,
      );
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
  Future<void> loadPrinted(String commandNumber) async {
    clear();

    try {
      await ticketIsPermitted.verify(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        commandNumber: commandNumber,
      );

      PrintedEntity? printedProducts = await loadPrintedProducts.load(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        commandNumber: int.tryParse(commandNumber) ?? 0,
      );

      if (printedProducts?.Products.isEmpty == false) {
        _printedProducts = PrintedViewModel.fromEntity(printedProducts!);
        _printedProducts!.Products
            .sort((a, b) => a.Products.Name.compareTo(b.Products.Name));
      }
    } catch (error) {
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
    _printedProducts = null;
  }

  @override
  Future<void> validateUserAndPermissionToCancelProducts({
    required int personalizedCode,
    required String password,
  }) async {
    isLoading = true;
    mainError = null;
    alertMessage = null;
    updateCanCancelProducts(false);

    try {
      final isValidPassword = await userValidations.isValidPassword(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        personalizedCode: personalizedCode,
        password: password,
      );

      if (!isValidPassword) {
        throw DomainError.invalidCredentials;
      }

      if (isValidPassword) {
        updateCanCancelProducts(
          await userValidations.canCancel(
            personalizedCode: personalizedCode,
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          ),
        );
      }
      if (!canCancelProducts) {
        throw DomainError.accessDenied;
      }

      if (canCancelProducts) {
        updateCanCancelProducts(true);
        alertMessage = R.string.msgSuccessToCancelProducts;
      }
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentialsOrAccessDenied:
          mainError = UIError.invalidCredentialsOrAccessDenied;
        case DomainError.accessDenied:
          mainError = UIError.accessDenied;
        case DomainError.invalidCredentials:
          mainError = UIError.invalidCredentials;
        default:
          mainError = UIError.unexpected;
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> loadCommandData({
    required PrintedProductsPresenter printedProductsPresenter,
    required CartPresenter cartPresenter,
    required MenuPresenter menuPresenter,
    required HomePresenter homePresenter,
    required bool clearPermissionToCancelProducts,
    required bool isRemovingProduct,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      if (isRemovingProduct && homePresenter.commandNumber == null) {
        throw DomainError.unexpected;
      }

      if (!isRemovingProduct) {
        homePresenter.updateCommandNumber(await barcodeScanner.read());
      }
      if (clearPermissionToCancelProducts) {
        updateCanCancelProducts(false);
      }
      menuPresenter.clear();
      cartPresenter.clear();

      await menuPresenter.getGroupsAndProducts(homePresenter.commandNumber!);
      await cartPresenter.loadSaleRequest(homePresenter.commandNumber!);
      clear();
      await loadPrinted(homePresenter.commandNumber!);
    } on DomainError catch (error) {
      homePresenter.updateCommandNumber(null);
      switch (error) {
        case DomainError.barcodeNotRead:
          mainError = UIError.barcodeNotRead;
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

  PrintedViewModel? _printedProducts;
  @override
  PrintedViewModel? get printedProducts => _printedProducts;

  final _isLoading = false.obs;
  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;
  set isLoading(bool value) => _isLoading.value = value;

  final _mainError = Rx<UIError?>(null);
  @override
  Stream<UIError?> get mainErrorStream => _mainError.stream;
  set mainError(UIError? value) => _mainError.value = value;

  bool _canCancelProducts = false;
  @override
  bool get canCancelProducts => _canCancelProducts;

  @override
  void updateCanCancelProducts(bool value) {
    _canCancelProducts = value;
    notifyListeners();
  }

  final _alertMessage = Rx<String?>(null);
  @override
  Stream<String?> get alertMessageStream => _alertMessage.stream;
  set alertMessage(String? value) => _alertMessage.value = value;
}
