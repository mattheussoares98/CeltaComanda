import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class EnterprisePresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<UIError?> get enterpriseErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<bool> get isFormValidStream;

  bool isUpdatedEnterpriseName = false;

  void validateEnterpriseInput(String value,
      {bool? updateEnterpriseNameController = false});

  Future<void> validateApiAndGoToHomePage({
    required bool isFixedCommandNumber,
    required String? commandNumber,
    required HomePresenter homePresenter,
  });
  Future<void> getFirebaseAndConcentradorEnterpriseParameters();
  Future<void> updateConcentratorEnterpriseParameters();
  Future<void> getLocalData();

  Future<void> goToHomePage(HomePresenter homePresenter);

  void updateEnterpriseEntity(EnterpriseEntity newEnterprise);
  Future<void> clearEnterpriseData();
}
