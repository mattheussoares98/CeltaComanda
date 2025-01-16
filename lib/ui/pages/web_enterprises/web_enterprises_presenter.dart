import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import '../../helpers/helpers.dart';

abstract class WebEnterprisesPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<List<EnterpriseEntity>?> get enterprisesStream;

  EnterpriseEntity? get selectedEnterprise;

  Future<void> loadEnterprises();
  void goToAddOrEditEnterprise(EnterpriseEntity? enterprise);
  Future<void> updateDevicesData(String enterpriseName);
}
