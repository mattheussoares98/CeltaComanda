import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class WebEnterprisesPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<List<EnterpriseEntity>?> get enterprisesStream;
  Stream<List<DeviceInfoViewModel>?> get devicesStream;

  Future<void> loadEnterprises();
  void goToAddOrEditEnterprise(EnterpriseEntity? enterprise);
  Future<void> updateDevicesData();
  Future<bool> updateEnterprise(EnterpriseEntity entity);

  Future<bool> deleteEnterpriseData();
  Future<void> getDevicesInfo();

  void goToDevicesInfoPage();
}
