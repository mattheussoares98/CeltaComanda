import '../../ui/helpers/helpers.dart';
import '../../domain/entities/entities.dart';
import 'models.dart';

class EnterpriseModel {
  final String enterpriseName;
  final String? url;
  final String? httpsUrl;
  final int? enterpriseId;
  final String? concentradorUrl;
  final bool? persistApp;
  final String? urlCCS;
  final bool? useCovenant;
  final EnterpriseConcentradorParametersEntity?
      enterpriseConcentradorParametersEntity;
  final double? serviceChargePercentageOrValue;
  final int? updateDevicesInformations;
  final int? updateEnterprise;
  final bool? zoomImage;
  final String? latestCompatibleVersion;
  final int? minutesVerifyUpdateMenu;
  final bool? useReducedNameOnProduct;
  final bool? verifyCommandBlocked;
  final bool? canInsertCommentManually;
  final bool? blockUseAppIfIsOutdated;
  final bool? canInsertQuantityManually;
  final bool? canInsertCustomer;
  final bool? requestTableNumber;
  final bool? useOldPrintWay;

  EnterpriseModel({
    required this.enterpriseName,
    required this.url,
    required this.httpsUrl,
    required this.enterpriseId,
    required this.concentradorUrl,
    required this.persistApp,
    required this.urlCCS,
    required this.useCovenant,
    required this.enterpriseConcentradorParametersEntity,
    required this.serviceChargePercentageOrValue,
    required this.updateDevicesInformations,
    required this.updateEnterprise,
    required this.zoomImage,
    required this.latestCompatibleVersion,
    required this.minutesVerifyUpdateMenu,
    required this.useReducedNameOnProduct,
    required this.verifyCommandBlocked,
    required this.canInsertCommentManually,
    required this.blockUseAppIfIsOutdated,
    required this.canInsertQuantityManually,
    required this.canInsertCustomer,
    required this.requestTableNumber,
    required this.useOldPrintWay,
  });

  factory EnterpriseModel.fromJson(
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
    return EnterpriseModel(
      url: json['url'],
      httpsUrl: json['httpsUrl'],
      enterpriseName: json["enterpriseName"],
      enterpriseId: json["enterpriseId"],
      concentradorUrl: json["concentradorUrl"],
      persistApp: json["persistApp"],
      urlCCS: json["urlCCS"],
      updateEnterprise: json["updateEnterprise"],
      useCovenant: json["useCovenant"],
      serviceChargePercentageOrValue:
          json["serviceChargePercentageOrValue"]?.toDouble(),
      updateDevicesInformations: json["updateDevicesInformations"],
      zoomImage: json["zoomImage"],
      enterpriseConcentradorParametersEntity:
          enterpriseConcentradorParametersEntity ??
              (json["enterpriseConcentradorParametersEntity"] == null
                  ? null
                  : EnterpriseConcentradorParametersModel.fromJson(
                          json["enterpriseConcentradorParametersEntity"])
                      .toEntity()),
      latestCompatibleVersion: json["latestCompatibleVersion"],
      minutesVerifyUpdateMenu: json["minutesVerifyUpdateMenu"],
      useReducedNameOnProduct: json["useReducedNameOnProduct"],
      verifyCommandBlocked: json["verifyCommandBlocked"],
      canInsertCommentManually: json["canInsertCommentManually"],
      blockUseAppIfIsOutdated: json["blockUseAppIfIsOutdated"],
      canInsertQuantityManually: json["canInsertQuantityManually"],
      canInsertCustomer: json["canInsertCustomer"],
      requestTableNumber: json["requestTableNumber"],
      useOldPrintWay: json["useOldPrintWay"],
    );
  }

  factory EnterpriseModel.fromEntity(EnterpriseEntity entity) =>
      EnterpriseModel(
        url: entity.url,
        httpsUrl: entity.httpsUrl,
        updateEnterprise: entity.updateEnterprise,
        enterpriseName: entity.enterpriseName,
        enterpriseId: entity.enterpriseId,
        concentradorUrl: entity.concentradorUrl,
        persistApp: entity.persistApp,
        urlCCS: entity.urlCCS,
        useCovenant: entity.useCovenant,
        serviceChargePercentageOrValue: entity.serviceChargePercentageOrValue,
        updateDevicesInformations: entity.updateDevicesInformations,
        enterpriseConcentradorParametersEntity:
            entity.enterpriseConcentradorParametersEntity,
        zoomImage: entity.zoomImage,
        latestCompatibleVersion: entity.latestCompatibleVersion,
        minutesVerifyUpdateMenu: entity.minutesVerifyUpdateMenu,
        useReducedNameOnProduct: entity.useReducedNameOnProduct,
        verifyCommandBlocked: entity.verifyCommandBlocked,
        canInsertCommentManually: entity.canInsertCommentManually,
        blockUseAppIfIsOutdated: entity.blockUseAppIfIsOutdated,
        canInsertQuantityManually: entity.canInsertQuantityManually,
        canInsertCustomer: entity.canInsertCustomer,
        requestTableNumber: entity.requestTableNumber,
        useOldPrintWay: entity.useOldPrintWay,
      );

  EnterpriseEntity toEntity() => EnterpriseEntity(
        enterpriseName: enterpriseName.toLowerCase().removeWhiteSpaces(),
        url: url?.toLowerCase().removeWhiteSpaces(),
        httpsUrl: httpsUrl?.toLowerCase().removeWhiteSpaces(),
        urlCCS: urlCCS?.toLowerCase().removeWhiteSpaces(),
        enterpriseId: enterpriseId,
        concentradorUrl: concentradorUrl?.toLowerCase().removeWhiteSpaces(),
        persistApp: persistApp,
        useCovenant: useCovenant,
        serviceChargePercentageOrValue: serviceChargePercentageOrValue,
        updateDevicesInformations: updateDevicesInformations,
        updateEnterprise: updateEnterprise,
        enterpriseConcentradorParametersEntity:
            enterpriseConcentradorParametersEntity,
        zoomImage: zoomImage,
        latestCompatibleVersion: latestCompatibleVersion,
        minutesVerifyUpdateMenu: minutesVerifyUpdateMenu,
        useReducedNameOnProduct: useReducedNameOnProduct,
        verifyCommandBlocked: verifyCommandBlocked,
        canInsertCommentManually: canInsertCommentManually,
        blockUseAppIfIsOutdated: blockUseAppIfIsOutdated,
        canInsertQuantityManually: canInsertQuantityManually,
        canInsertCustomer: canInsertCustomer,
        requestTableNumber: requestTableNumber,
        useOldPrintWay: useOldPrintWay,
      );

  Map<String, dynamic> toJson() => {
        'enterpriseName': enterpriseName.toLowerCase().removeWhiteSpaces(),
        'enterpriseId': enterpriseId,
        'url': url?.toLowerCase().removeWhiteSpaces(),
        'httpsUrl': httpsUrl?.toLowerCase().removeWhiteSpaces(),
        'concentradorUrl': concentradorUrl?.toLowerCase().removeWhiteSpaces(),
        'persistApp': persistApp,
        'urlCCS': urlCCS,
        'useCovenant': useCovenant,
        'updateEnterprise': updateEnterprise,
        'serviceChargePercentageOrValue': serviceChargePercentageOrValue,
        'updateDevicesInformations': updateDevicesInformations,
        'enterpriseConcentradorParametersEntity':
            enterpriseConcentradorParametersEntity != null
                ? EnterpriseConcentradorParametersModel.fromEntity(
                        enterpriseConcentradorParametersEntity!)
                    .toJson()
                : null,
        'zoomImage': zoomImage,
        'latestCompatibleVersion': latestCompatibleVersion,
        'minutesVerifyUpdateMenu': minutesVerifyUpdateMenu,
        'useReducedNameOnProduct': useReducedNameOnProduct,
        'verifyCommandBlocked': verifyCommandBlocked,
        'canInsertCommentManually': canInsertCommentManually,
        'blockUseAppIfIsOutdated': blockUseAppIfIsOutdated,
        'canInsertQuantityManually': canInsertQuantityManually,
        'canInsertCustomer': canInsertCustomer,
        'requestTableNumber': requestTableNumber,
        'useOldPrintWay': useOldPrintWay,
      };
}
