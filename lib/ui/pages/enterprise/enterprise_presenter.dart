import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class EnterprisePresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<UIError?> get enterpriseErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<bool> get isFormValidStream;
  Stream<List<PdvNotUsingViewModel>?> get pdvsNotUsingStream;

  bool isUpdatedEnterpriseName = false;

  void validateEnterpriseInput(String value,
      {bool? updateEnterpriseNameController = false});

  Future<void> validateEnterpriseByName({
    required bool isFixedCommandNumber,
    required String? commandNumber,
    required HomePresenter homePresenter,
  });

  Future<void> updateConcentratorEnterpriseParameters();
  Future<void> updateEnterpriseWithLocalData();

  Future<void> clearEnterpriseData();
}
