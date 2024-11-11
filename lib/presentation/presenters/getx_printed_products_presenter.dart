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
    required String commandNumber,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      await removePrintedProduct.remove(saleRequestProductId);

      await loadPrinted(commandNumber);
    } on DomainError catch (error) {
      await loadPrinted(commandNumber);
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
    isLoading = true;
    mainError = null;

    try {
      PrintedEntity? printedProducts = await loadPrintedProducts.load(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        commandNumber: commandNumber.toInt(),
      );

      _printed = null;
      if (printedProducts?.Products.isEmpty == false) {
        _printed = PrintedViewModel.fromEntity(printedProducts!);
        _printed!.Products.sort((a, b) => DateTime.parse(a.DateHourOfCreation)
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
    _printed = null;
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

  PrintedViewModel? _printed;
  @override
  PrintedViewModel? get printed => _printed;

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
  double getTotalLiquid(PrintedViewModel? printed) {
    if (printed == null) {
      return 0;
    }

    final serviceChargeValue = getServiceChargeValue(printed);

    double value =
        (printed.TotalLiquid.toDouble() + serviceChargeValue.toDouble());

    return value.roundAccordingBs().toStringAsFixed(2).toDouble();
  }

  @override
  double getServiceChargeValue(PrintedViewModel? printed) {
    if (printed == null) {
      return 0;
    }

    double value;

    if (printed.IncrementType.toInt() == 1) {
      //value
      value = printed.IncrementValue.toDouble();
    } else if (printed.IncrementType.toInt() == 2) {
      //percentage
      value = printed.TotalLiquid.toDouble() *
          (printed.IncrementValue.toDouble() / 100);
    } else {
      return 0;
    }

    return value.roundAccordingBs().toStringAsFixed(2).toDouble();
  }

  @override
  Future<void> removeServiceCharge({
    required int userPersonalizedCode,
    required String password,
    required String commandNumber,
    required int saleRequestId,
  }) async {
    isLoading = true;
    mainError = null;
    try {
      bool isValid = await userValidations.isValidPassword(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        personalizedCode: userPersonalizedCode,
        password: password,
      );

      if (!isValid) {
        throw DomainError.invalidCredentialsOrAccessDenied;
      }

      final model = SaleRequestModel(
        CovenantCode: null,
        CustomerCode: null,
        IncrementType: 0,
        IncrementValue: 0,
        TotalLiquid: _printed!.TotalLiquid.toDouble(),
        EnterpriseId: EnterpriseDataBuilder.enterpriseDataEntity?.enterpriseId,
      );

      await updateSaleRequest.update(
        model: model,
        commandNumberWithThreeNumbers: commandNumber.padLeft(3, "0"),
        saleRequestId: saleRequestId,
      );

      await loadPrinted(commandNumber);
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
