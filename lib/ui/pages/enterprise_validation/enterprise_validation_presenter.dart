import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class EnterpriseValidationPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<UIError?> get enterpriseErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<bool> get isFormValidStream;
  Stream<CommandViewModel?> get commandDataStream;

  bool isUpdatedEnterpriseName = false;

  TextEditingController get enterpriseNameController;

  void validateEnterpriseInput(String value,
      {bool? updateEnterpriseNameController = false});
  void updateEnterpriseController(String value);

  Future<void> validateApiAndGoToHomePage({
    required CommandEntity commandEntity,
    required HomePresenter homePresenter,
  });
  Future<void> getFirebaseAndConcentradorEnterpriseParameters();
  Future<void> getLocalData(HomePresenter homePresenter);

  Future<void> goToHomePage(HomePresenter homePresenter);

  Future<void> updateUseFixedCommandNumber(HomePresenter homePresenter);
  void updateCommandNumber({
    required String? newCommandValue,
    required HomePresenter homePresenter,
  });
  // Future<void> updateEnterpriseEntity(Map<String, dynamic> enterpriseData);
}
