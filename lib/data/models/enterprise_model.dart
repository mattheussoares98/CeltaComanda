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
  final int? updateMenuCount;
  final int? updateEnterpriseCount;
  final EnterpriseConcentradorParametersEntity?
      enterpriseConcentradorParametersEntity;
  final double? serviceChargePercentageOrValue;
  final int? serviceChargeType;
  final int? updateDevicesInformations;

  EnterpriseValidationModel({
    required this.enterpriseName,
    required this.url,
    required this.enterpriseId,
    required this.concentradorUrl,
    required this.persistApp,
    required this.urlCCS,
    required this.useCovenant,
    required this.enterpriseConcentradorParametersEntity,
    required this.updateMenuCount,
    required this.updateEnterpriseCount,
    required this.serviceChargePercentageOrValue,
    required this.serviceChargeType,
    required this.updateDevicesInformations,
  });

  factory EnterpriseValidationModel.fromJson(Map json) {
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
      useCovenant: json["useCovenant"],
      updateMenuCount: json["updateMenuCount"],
      updateEnterpriseCount: json["updateEnterpriseCount"],
      serviceChargePercentageOrValue:
          json["serviceChargePercentageOrValue"]?.toDouble(),
      serviceChargeType: json["serviceChargeType"],
      updateDevicesInformations: json["updateDevicesInformations"],
      enterpriseConcentradorParametersEntity:
          json["enterpriseConcentradorParametersEntity"] == null
              ? null
              : EnterpriseConcentradorParametersModel.fromJson(
                      json["enterpriseConcentradorParametersEntity"])
                  .toEntity(),
    );
  }

  factory EnterpriseValidationModel.fromEntity(EnterpriseEntity entity) =>
      EnterpriseValidationModel(
        url: entity.url,
        enterpriseName: entity.enterpriseName,
        enterpriseId: entity.enterpriseId,
        concentradorUrl: entity.concentradorUrl,
        persistApp: entity.persistApp,
        urlCCS: entity.urlCCS,
        useCovenant: entity.useCovenant,
        updateMenuCount: entity.updateMenuCount,
        updateEnterpriseCount: entity.updateEnterpriseCount,
        serviceChargePercentageOrValue: entity.serviceChargePercentageOrValue,
        serviceChargeType: entity.serviceChargeType,
        updateDevicesInformations: entity.updateDevicesInformations,
        enterpriseConcentradorParametersEntity:
            entity.enterpriseConcentradorParametersEntity,
      );

  EnterpriseEntity toEntity() => EnterpriseEntity(
        enterpriseName: enterpriseName.toLowerCase().removeWhiteSpaces(),
        url: url?.toLowerCase().removeWhiteSpaces(),
        urlCCS: urlCCS?.toLowerCase().removeWhiteSpaces(),
        enterpriseId: enterpriseId,
        concentradorUrl: concentradorUrl?.toLowerCase().removeWhiteSpaces(),
        persistApp: persistApp,
        useCovenant: useCovenant,
        updateMenuCount: updateMenuCount,
        updateEnterpriseCount: updateEnterpriseCount,
        serviceChargePercentageOrValue: serviceChargePercentageOrValue,
        serviceChargeType: serviceChargeType,
        updateDevicesInformations: updateDevicesInformations,
        enterpriseConcentradorParametersEntity:
            enterpriseConcentradorParametersEntity,
      );

  Map<String, dynamic> toJson() => {
        'enterpriseName': enterpriseName.toLowerCase().removeWhiteSpaces(),
        'enterpriseId': enterpriseId,
        'url': url?.toLowerCase().removeWhiteSpaces(),
        'concentradorUrl': concentradorUrl?.toLowerCase().removeWhiteSpaces(),
        'persistApp': persistApp,
        'urlCCS': urlCCS,
        'useCovenant': useCovenant,
        'updateMenuCount': updateMenuCount,
        'updateEnterpriseCount': updateEnterpriseCount,
        'serviceChargePercentageOrValue': serviceChargePercentageOrValue,
        'updateDevicesInformations': updateDevicesInformations,
        'serviceChargeType': serviceChargeType,
        'enterpriseConcentradorParametersEntity':
            enterpriseConcentradorParametersEntity != null
                ? EnterpriseConcentradorParametersModel.fromEntity(
                        enterpriseConcentradorParametersEntity!)
                    .toJson()
                : null,
      };
}
