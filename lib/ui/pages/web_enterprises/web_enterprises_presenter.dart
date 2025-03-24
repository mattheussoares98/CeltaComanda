import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class WebEnterprisesPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<List<EnterpriseEntity>?> get enterprisesStream;
  Stream<List<DeviceInfoViewModel>?> get devicesStream;

  EnterpriseEntity? get selectedEnterprise;

  Future<void> loadEnterprises();
  void goToAddOrEditEnterprise(EnterpriseEntity? enterprise);
  Future<void> updateDevicesData();
  Future<bool> updateEnterprise({
    required String navsUrl,
    required String concentratorUrl,
    required String ccsUrl,
    required int enterpriseId,
    required int? minutesVerifyUpdateMenu,
    required String? latestCompatibleVersion,
    required double? serviceChargePercentage,
    required bool? zoomImage,
    required bool? useCovenant,
    required String enterpriseName,
    required bool? useReducedNameOnProduct,
    required bool? verifyCommandBlocked,
    required bool? canInsertCommentManually,
    required bool? blockUseAppIfIsOutdated,
  });

  Future<bool> deleteEnterpriseData();
  Future<void> getDevicesInfo();

  void goToDevicesInfoPage();
}
