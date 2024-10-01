import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';

abstract class CovenantPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<UIError?> get customerErrorStream;
  Stream<bool> get isLoadingStream;

  Future<void> getCustomer(String value);
  void validateCustomerField(String value);
}
