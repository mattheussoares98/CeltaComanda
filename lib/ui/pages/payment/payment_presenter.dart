import 'package:flutter/material.dart';

import '../../../data/models/models.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../presentation/protocols/protocols.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class PaymentPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<bool> get updateScreenStream;
  double get totalPaidValue;
  ConcentratorFinalizationModel? get lastRequestedPaymentFinalization;
  List<ConcentratorFinalizationModel> get successfulPayments;
  Stream<ValidationError?> get customerErrorStream;
  Stream<List<CustomerViewModel>?> get customersViewModelStream;
  Map<String, String?> get selectedCovenant;
  AuthorizationPendingModel? get authorizationPendingModel;
  int? get couponNumber;

  Future<void> callPayment({
    required double longAmountValue,
    required int portionQuantity,
    required PaymentMode paymentMode,
    required HomePresenter homePresenter,
  });

  Future<void> liquidateCommand({
    required PrintedProductsPresenter printedProductsPresenter,
    required HomePresenter homePresenter,
    required void Function() showSuccessAndCloseUntilHomePage,
  });

  void initPaymentResultHandler({
    required HomePresenter homePresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required void Function() showSuccessAndCloseUntilHomePage,
  });

  void disposePaymentResultHandler();

  void goToCovenantPage();

  double getTotalPendingValue(
    PrintedProductsPresenter printedProductsPresenter,
  );

  Future<void> getCustomerByNameCodeOrCpf({
    required String value,
    required bool searchByPersonalizedCode,
    required void Function(String error) showErrorMessageReturnedByBs,
  });
  void validateCustomerField(String value);
  Future<void> updateSelectedCovenant(
    CustomerViewModel? customer,
    String? newValue,
  );
  Future<void> finishSaleRequestByCovenant({
    required HomePresenter homePresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required void Function(String error) showErrorMessageReturnedByBs,
    required void Function() showSuccessAndCloseUntilHomePage,
    required String? customerPassword,
    required int? cpf,
    required int? cnpj,
  });

  void clearPayments();
  bool useUrlSatSharing();
}
