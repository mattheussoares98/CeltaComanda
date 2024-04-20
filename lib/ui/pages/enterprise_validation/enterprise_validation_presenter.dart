import '../../../domain/entities/entities.dart';
import '../../helpers/helpers.dart';

import 'package:flutter/material.dart';

abstract class EnterpriseValidationPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<UIError?> get enterpriseErrorStream;
  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingStream;

  bool isUpdatedEnterpriseName = false;

  TextEditingController get enterpriseNameController;

  LoginDataEntity? get loginData;

  void validateEnterpriseInput(String enterprise);
  void validateEnterprise();
  Future<void> loadRemoteData();
  Future<void> loadLocalData();
  void updateEnterpriseText(ApiSaleRequestEntity? entity);
}
