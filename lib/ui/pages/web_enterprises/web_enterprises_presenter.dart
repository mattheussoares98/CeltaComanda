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
  Future<void> updateDevicesData();
  Future<bool> updateEnterprise({
    required String navsUrl,
    required String concentratorUrl,
    required String ccsUrl,
    required int enterpriseId,
    required int? daysPreloadImage,
    required String? latestCompatibleVersion,
    required double? serviceChargePercentage,
    required bool? zoomImage,
    required bool? useCovenant,
    required String enterpriseName,
  });

  Future<bool> deleteEnterpriseData();
}
