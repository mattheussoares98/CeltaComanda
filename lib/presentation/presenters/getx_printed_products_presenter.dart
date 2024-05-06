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
    required HomePresenter homePresenter,
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
        mainError = UIError.invalidCredentials;
      }

      bool canCancel = false;
      if (isValidPassword) {
        canCancel = await userValidations.canCancel(
          personalizedCode: personalizedCode,
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        );
      }
      if (!canCancel) {
        mainError = UIError.accessDenied;
      }

      if (canCancel) {
        await removePrintedProduct.remove(
          productId: saleRequestProductId,
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        );

        await homePresenter.load(
          commandNumber: homePresenter.commandNumber!,
          printedProductsPresenter: printedProductsPresenter,
          saleRequestTempPresenter: saleRequestTempPresenter,
          expansibleGroupsPresenter: expansibleGroupsPresenter,
        );
      }
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          mainError = UIError.invalidCredentials;
        case DomainError.accessDenied:
          mainError = UIError.accessDenied;
        default:
          mainError = UIError.unexpected;
      }
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> load(String commandNumber) async {
    clear();
    mainError = null;

    try {
      PrintedEntity? printedProducts = await loadPrintedProducts.load(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        commandNumber: int.tryParse(commandNumber) ?? 0,
      );

      if (printedProducts != null) {
        _printedProducts = PrintedViewModel.fromEntity(printedProducts);
      }
      notifyListeners();
    } catch (error) {
      mainError = UIError.unexpected;
    }
  }

  PrintedViewModel? _printedProducts;
  @override
  PrintedViewModel? get printedProducts => _printedProducts;

  @override
  void clear() {
    _printedProducts = null;
    notifyListeners();
  }

  final _isLoading = false.obs;
  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;
  set isLoading(bool value) {
    _isLoading.value = value;
  }

  final _mainError = Rx<UIError?>(null);
  @override
  Stream<UIError?> get mainErrorStream => _mainError.stream;
  set mainError(UIError? value) => _mainError.value = value;
}
