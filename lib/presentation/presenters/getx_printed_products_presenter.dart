import 'package:clean_celta_mobile/data/models/models.dart';
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
  final UpdateSaleRequest updateSaleRequest;

  GetxPrintedProductsPresenter({
    required this.userValidations,
    required this.loadPrintedProducts,
    required this.removePrintedProduct,
    required this.updateSaleRequest,
  });

  @override
  Future<void> removeProduct({
    required String saleRequestProductId,
    required MenuPresenter menuPresenter,
    required CartPresenter cartPresenter,
    required HomePresenter homePresenter,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      await removePrintedProduct.remove(
        productId: saleRequestProductId,
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
      );

      await loadPrinted(homePresenter);
    } on DomainError catch (error) {
      await loadPrinted(homePresenter);
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
  Future<void> loadPrinted(HomePresenter homePresenter) async {
    isLoading = true;
    mainError = null;

    try {
      PrintedEntity? printedProducts = await loadPrintedProducts.load(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        commandNumber: homePresenter.commandNumber!.toInt(),
      );

      _printedProducts = null;
      if (printedProducts?.Products.isEmpty == false) {
        _printedProducts = PrintedViewModel.fromEntity(printedProducts!);
        _printedProducts!.Products.sort((a, b) =>
            DateTime.parse(a.DateHourOfCreation)
                .compareTo(DateTime.parse(b.DateHourOfCreation)));
      }
    } catch (error) {
      switch (error) {
        case DomainError.commandNotAvailable:
          mainError = UIError.commandNotAvailable;
          throw DomainError.commandNotAvailable;
        default:
          mainError = UIError.unexpected;
          throw DomainError.unexpected;
      }
    } finally {
      isLoading = false;
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

  @override
  void doOnClosePage() {
    _canCancelProducts = false;
  }

  @override
  double get totalLiquid {
    if (_printedProducts == null) {
      return 0;
    }

    return _printedProducts!.TotalLiquid.toDouble() + serviceChargeValue;
  }

  @override
  double get serviceChargeValue {
    if (_printedProducts == null) {
      return 0;
    }

    if (_printedProducts!.IncrementType.toInt() == 1) {
      //value
      return _printedProducts!.IncrementValue.toDouble();
    } else if (_printedProducts!.IncrementType.toInt() == 2) {
      //percentage
      return _printedProducts!.TotalLiquid.toDouble() *
          (_printedProducts!.IncrementValue.toDouble() / 100);
    } else {
      return 0;
    }
  }

  @override
  Future<void> removeServiceCharge({
    required int personalizedCode,
    required String password,
    required HomePresenter homePresenter,
  }) async {
    isLoading = true;
    mainError = null;
    try {
      bool isValid = await userValidations.isValidPassword(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        personalizedCode: personalizedCode,
        password: password,
      );

      if (!isValid) {
        throw DomainError.invalidCredentialsOrAccessDenied;
      }

      await updateSaleRequest.update(
        model: SaleRequestModel(
          CovenantCode: null,
          CustomerCode: null,
          IncrementType: 0,
          IncrementValue: 0,
          TotalLiquid: _printedProducts!.TotalLiquid.toDouble(),
        ),
        commandNumberWithThreeNumbers:
            homePresenter.commandNumber!.padLeft(3, "0"),
        saleRequestId: _printedProducts!.SaleRequestId.toInt(),
      );

      await loadPrinted(homePresenter);
    } on DomainError catch (e) {
      switch (e) {
        case DomainError.invalidCredentialsOrAccessDenied:
          mainError = UIError.invalidCredentialsOrAccessDenied;
        default:
          mainError = UIError.unexpected;
      }
    } finally {
      isLoading = false;
    }
  }
}
