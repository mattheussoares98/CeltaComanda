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
  void updateSelectedCovenant(CustomerViewModel customer, String? newValue);
  Future<void> updateCustomerAndCovenantAndFinishSaleRequestTemp(
    HomePresenter homePresenter,
  );
}
