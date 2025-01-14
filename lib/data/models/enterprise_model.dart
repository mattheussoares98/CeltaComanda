import '../../ui/helpers/helpers.dart';
import '../../domain/entities/entities.dart';
import 'models.dart';

class EnterpriseValidationModel {
  final String enterpriseName;
  final String? url;
  final int? enterpriseId;
  final String? concentradorUrl;
  final bool? persistApp;
  final String? urlCCS;
  final bool? useCovenant;
  final int? updateMenu;
  final int? updateConcentratorEnterpriseData;
  final EnterpriseConcentradorParametersEntity?
      enterpriseConcentradorParametersEntity;
  final double? serviceChargePercentageOrValue;
  final int? serviceChargeType;
  final int? updateDevicesInformations;
  final int? updateEnterprise;
  final bool? zoomImage;
  final List<String>? pendingDevicesToUpdate;
  final int? updatePendingDevices;
  final int? waitDaysToPreloadImages;
  final int? secondsPreloadingImages;
  final String? latestCompatibleVersion;

  EnterpriseValidationModel({
    required this.enterpriseName,
    required this.url,
    required this.enterpriseId,
    required this.concentradorUrl,
    required this.persistApp,
    required this.urlCCS,
    required this.useCovenant,
    required this.enterpriseConcentradorParametersEntity,
    required this.updateMenu,
    required this.updateConcentratorEnterpriseData,
    required this.serviceChargePercentageOrValue,
    required this.serviceChargeType,
    required this.updateDevicesInformations,
    required this.updateEnterprise,
    required this.zoomImage,
    required this.pendingDevicesToUpdate,
    required this.updatePendingDevices,
    required this.waitDaysToPreloadImages,
    required this.secondsPreloadingImages,
    required this.latestCompatibleVersion,
  });

  factory EnterpriseValidationModel.fromJson(
    Map json, {
    EnterpriseConcentradorParametersEntity?
        enterpriseConcentradorParametersEntity,
  }) {
    if (!json.keys.toSet().containsAll([
      'url',
      'enterpriseId',
      'enterpriseName',
      'concentradorUrl',
    ])) {
      throw Exception();
    }
    return EnterpriseValidationModel(
      url: json['url'],
      enterpriseName: json["enterpriseName"],
      enterpriseId: json["enterpriseId"],
      concentradorUrl: json["concentradorUrl"],
      persistApp: json["persistApp"],
      urlCCS: json["urlCCS"],
      updateEnterprise: json["updateEnterprise"],
      useCovenant: json["useCovenant"],
      updateMenu: json["updateMenu"],
      updateConcentratorEnterpriseData:
          json["updateConcentratorEnterpriseData"],
      serviceChargePercentageOrValue:
          json["serviceChargePercentageOrValue"]?.toDouble(),
      serviceChargeType: json["serviceChargeType"],
      updateDevicesInformations: json["updateDevicesInformations"],
      zoomImage: json["zoomImage"],
      pendingDevicesToUpdate:
          json["pendingDevicesToUpdate"]?.map((e) => e).toList().cast<String>(),
      updatePendingDevices: json["updatePendingDevices"],
      enterpriseConcentradorParametersEntity:
          enterpriseConcentradorParametersEntity ??
              (json["enterpriseConcentradorParametersEntity"] == null
                  ? null
                  : EnterpriseConcentradorParametersModel.fromJson(
                          json["enterpriseConcentradorParametersEntity"])
                      .toEntity()),
      waitDaysToPreloadImages: json["waitDaysToPreloadImages"],
      secondsPreloadingImages: json["secondsPreloadingImages"],
      latestCompatibleVersion: json["latestCompatibleVersion"],
    );
  }

  factory EnterpriseValidationModel.fromEntity(EnterpriseEntity entity) =>
      EnterpriseValidationModel(
        url: entity.url,
        updateEnterprise: entity.updateEnterprise,
        enterpriseName: entity.enterpriseName,
        enterpriseId: entity.enterpriseId,
        concentradorUrl: entity.concentradorUrl,
        persistApp: entity.persistApp,
        urlCCS: entity.urlCCS,
        useCovenant: entity.useCovenant,
        updateMenu: entity.updateMenu,
        updateConcentratorEnterpriseData:
            entity.updateConcentratorEnterpriseData,
        serviceChargePercentageOrValue: entity.serviceChargePercentageOrValue,
        serviceChargeType: entity.serviceChargeType,
        updateDevicesInformations: entity.updateDevicesInformations,
        enterpriseConcentradorParametersEntity:
            entity.enterpriseConcentradorParametersEntity,
        zoomImage: entity.zoomImage,
        pendingDevicesToUpdate: entity.pendingDevicesToUpdate,
        updatePendingDevices: entity.updatePendingDevices,
        waitDaysToPreloadImages: entity.waitDaysToPreloadImages,
        secondsPreloadingImages: entity.secondsPreloadingImages,
        latestCompatibleVersion: entity.latestCompatibleVersion,
      );

  EnterpriseEntity toEntity() => EnterpriseEntity(
        enterpriseName: enterpriseName.toLowerCase().removeWhiteSpaces(),
        url: url?.toLowerCase().removeWhiteSpaces(),
        urlCCS: urlCCS?.toLowerCase().removeWhiteSpaces(),
        enterpriseId: enterpriseId,
        concentradorUrl: concentradorUrl?.toLowerCase().removeWhiteSpaces(),
        persistApp: persistApp,
        useCovenant: useCovenant,
        updateMenu: updateMenu,
        updateConcentratorEnterpriseData: updateConcentratorEnterpriseData,
        serviceChargePercentageOrValue: serviceChargePercentageOrValue,
        serviceChargeType: serviceChargeType,
        updateDevicesInformations: updateDevicesInformations,
        updateEnterprise: updateEnterprise,
        enterpriseConcentradorParametersEntity:
            enterpriseConcentradorParametersEntity,
        zoomImage: zoomImage,
        pendingDevicesToUpdate: pendingDevicesToUpdate,
        updatePendingDevices: updatePendingDevices,
        waitDaysToPreloadImages: waitDaysToPreloadImages,
        secondsPreloadingImages: secondsPreloadingImages,
        latestCompatibleVersion: latestCompatibleVersion,
      );

  Map<String, dynamic> toJson() => {
        'enterpriseName': enterpriseName.toLowerCase().removeWhiteSpaces(),
        'enterpriseId': enterpriseId,
        'url': url?.toLowerCase().removeWhiteSpaces(),
        'concentradorUrl': concentradorUrl?.toLowerCase().removeWhiteSpaces(),
        'persistApp': persistApp,
        'urlCCS': urlCCS,
        'useCovenant': useCovenant,
        'updateMenu': updateMenu,
        'updateEnterprise': updateEnterprise,
        'updateConcentratorEnterpriseData': updateConcentratorEnterpriseData,
        'serviceChargePercentageOrValue': serviceChargePercentageOrValue,
        'updateDevicesInformations': updateDevicesInformations,
        'serviceChargeType': serviceChargeType,
        'enterpriseConcentradorParametersEntity':
            enterpriseConcentradorParametersEntity != null
                ? EnterpriseConcentradorParametersModel.fromEntity(
                        enterpriseConcentradorParametersEntity!)
                    .toJson()
                : null,
        'zoomImage': zoomImage,
        'pendingDevicesToUpdate': pendingDevicesToUpdate,
        'updatePendingDevices': updatePendingDevices,
        'waitDaysToPreloadImages': waitDaysToPreloadImages,
        'secondsPreloadingImages': secondsPreloadingImages,
        'latestCompatibleVersion': latestCompatibleVersion,
      };
}
