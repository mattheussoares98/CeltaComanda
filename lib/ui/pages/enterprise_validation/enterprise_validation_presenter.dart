import '../../helpers/helpers.dart';

import 'package:flutter/material.dart';

abstract class EnterpriseValidationPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<UIError?> get enterpriseErrorStream;
  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingStream;
  Stream<bool> get useFixedCommandNumber;

  bool isUpdatedEnterpriseName = false;

  TextEditingController get enterpriseNameController;

  void validateEnterpriseInput(String value,
      {bool? updateEnterpriseNameController = false});
  void updateEnterpriseController(String value);

  Future<void> validateApiSaleRequest({required bool useFixedCommandNumber});
  Future<void> loadRemoteEnterpriseData();
  Future<void> loadLocalData();

  void goToHomePage();

  void updateUseFixedCommandNumber();
}
