import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxPrintedProductsPresenter
    with ChangeNotifier
    implements PrintedProductsPresenter {
  final UserValidations userValidations;
  final LoadPrintedProducts loadPrintedProducts;
  final RemovePrintedProduct removePrintedProduct;

  GetxPrintedProductsPresenter({
    required this.userValidations,
    required this.loadPrintedProducts,
    required this.removePrintedProduct,
  });

  @override
  Future<void> removeProduct({
    required int personalizedCode,
    required String password,
    required String saleRequestProductId,
    required ExpansibleGroupsPresenter expansibleGroupsPresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      final isValidPassword = await userValidations.isValidPassword(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        personalizedCode: personalizedCode,
        password: password,
      );

      if (!isValidPassword) {
        throw DomainError.invalidCredentials;
      }

      bool canCancel = false;
      if (isValidPassword) {
        canCancel = await userValidations.canCancel(
          personalizedCode: personalizedCode,
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        );
      }
      if (!canCancel) {
        throw DomainError.accessDenied;
      }

      if (canCancel) {
        await removePrintedProduct.remove(
          productId: saleRequestProductId,
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        );

        await expansibleGroupsPresenter.load(
          commandNumber: expansibleGroupsPresenter.commandNumber!,
          printedProductsPresenter: printedProductsPresenter,
          saleRequestTempPresenter: saleRequestTempPresenter,
        );
      }
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          mainError = UIError.invalidCredentials;
          break;
        case DomainError.accessDenied:
          mainError = UIError.accessDenied;
          break;
        default:
          mainError = UIError.unexpected;
      }
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> load(String commandNumber) async {
    isLoading = true;
    mainError = null;
    clear();
    notifyListeners();

    try {
      notifyListeners();

      PrintedEntity? printedProducts = await loadPrintedProducts.load(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        commandNumber: int.tryParse(commandNumber) ?? 0,
      );

      if (printedProducts != null) {
        _printedProducts = PrintedViewModel.fromEntity(printedProducts);
      }
    } catch (error) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  PrintedViewModel? _printedProducts;
  @override
  PrintedViewModel? get printedProducts => _printedProducts;

  final _mainError = Rx<UIError?>(null);

  @override
  Stream<UIError?> get mainErrorStream => _mainError.stream;
  set mainError(UIError? value) => _mainError.value = value;

  @override
  void clear() {
    _printedProducts = null;
  }

  final _isLoading = false.obs;
  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;
  set isLoading(bool value) {
    _isLoading.value = value;
    notifyListeners();
  }
}
