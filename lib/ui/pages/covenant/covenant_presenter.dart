import 'package:flutter/material.dart';

import '../../../presentation/protocols/protocols.dart';
import '../../helpers/helpers.dart';

abstract class CovenantPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<ValidationError?> get customerErrorStream;
  Stream<bool> get isLoadingStream;

  Future<void> getCustomer(String value);
  void validateCustomerField(String value);
}
