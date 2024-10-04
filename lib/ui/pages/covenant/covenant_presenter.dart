import 'package:flutter/material.dart';

import '../../../presentation/protocols/protocols.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class CovenantPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<ValidationError?> get customerErrorStream;
  Stream<List<CustomerViewModel>?> get customersViewModelStream;
  Map<String, String?> get selectedCovenant;

  Future<void> getCustomer(String value);
  void validateCustomerField(String value);
  Future<void> updateSelectedCovenant(
      CustomerViewModel customer, String? newValue);
  Future<void> finishSaleRequestByCovenant({
    required HomePresenter homePresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required void Function() closePagesUntilHomePage,
    required void Function(String error) showErrorMessageReturnedByBs,
  });
  Future<bool> getCovenantAuthorizationIsPendant();
}
