import 'package:equatable/equatable.dart';

import 'entities.dart';

class EnterpriseEntity extends Equatable {
  final String enterpriseName;
  final String? url;
  final int? enterpriseId;
  final String? concentradorUrl;
  final bool? persistApp;
  final String? urlCCS;
  final bool? useCovenant;
  final int? updateMenu;
  final int? updateDevicesInformations;
  final int? updateEnterprise;
  final EnterpriseConcentradorParametersEntity?
      enterpriseConcentradorParametersEntity;
  final double? serviceChargePercentageOrValue;
  final int? serviceChargeType;
  final bool? zoomImage;
  final List<String>? pendingDevicesToUpdate;
  final int? updatePendingDevices;
  final int? waitDaysToPreloadImages;
  final String? latestCompatibleVersion;
  final int? minutesVerifyUpdateMenu;
  //TODO remove unecessary parameters

  const EnterpriseEntity({
    required this.enterpriseName,
    required this.url,
    required this.enterpriseId,
    required this.concentradorUrl,
    required this.persistApp,
    required this.urlCCS,
    required this.useCovenant,
    required this.enterpriseConcentradorParametersEntity,
    required this.updateMenu,
    required this.serviceChargePercentageOrValue,
    required this.serviceChargeType,
    required this.updateDevicesInformations,
    required this.updateEnterprise,
    required this.zoomImage,
    required this.pendingDevicesToUpdate,
    required this.updatePendingDevices,
    required this.waitDaysToPreloadImages,
    required this.latestCompatibleVersion,
    required this.minutesVerifyUpdateMenu,
  });

  @override
  List get props => [
        url,
        enterpriseName,
        enterpriseId,
        concentradorUrl,
        persistApp,
        urlCCS,
        useCovenant,
        enterpriseConcentradorParametersEntity,
        updateMenu,
        serviceChargePercentageOrValue,
        serviceChargeType,
        updateDevicesInformations,
        updateEnterprise,
        zoomImage,
        pendingDevicesToUpdate,
        updatePendingDevices,
        waitDaysToPreloadImages,
        latestCompatibleVersion,
        minutesVerifyUpdateMenu,
      ];
}
