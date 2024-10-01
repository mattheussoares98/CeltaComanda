import 'package:flutter/material.dart';

import '../../../presentation/protocols/protocols.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class CovenantPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<ValidationError?> get customerErrorStream;
  Stream<CustomerViewModel?> get customerViewModelStream;

  Future<void> getCustomer(String value);
  void validateCustomerField(String value);
}
