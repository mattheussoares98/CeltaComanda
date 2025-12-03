// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  final int? updateDevicesInformations;
  final int? updateEnterprise;
  final EnterpriseConcentradorParametersEntity?
      enterpriseConcentradorParametersEntity;
  final double? serviceChargePercentageOrValue;
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

  const EnterpriseEntity({
    required this.enterpriseName,
    required this.url,
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
        serviceChargePercentageOrValue,
        updateDevicesInformations,
        updateEnterprise,
        zoomImage,
        latestCompatibleVersion,
        minutesVerifyUpdateMenu,
        useReducedNameOnProduct,
        verifyCommandBlocked,
        canInsertCommentManually,
        blockUseAppIfIsOutdated,
        canInsertQuantityManually,
        canInsertCustomer,
        requestTableNumber,
        useOldPrintWay,
      ];

  EnterpriseEntity copyWith({
    String? enterpriseName,
    String? url,
    int? enterpriseId,
    String? concentradorUrl,
    bool? persistApp,
    String? urlCCS,
    bool? useCovenant,
    int? updateDevicesInformations,
    int? updateEnterprise,
    double? serviceChargePercentageOrValue,
    bool? zoomImage,
    String? latestCompatibleVersion,
    int? minutesVerifyUpdateMenu,
    bool? useReducedNameOnProduct,
    bool? verifyCommandBlocked,
    bool? canInsertCommentManually,
    bool? blockUseAppIfIsOutdated,
    bool? canInsertQuantityManually,
    bool? canInsertCustomer,
    bool? requestTableNumber,
    bool? useOldPrintWay,
  }) {
    return EnterpriseEntity(
      enterpriseConcentradorParametersEntity:
          enterpriseConcentradorParametersEntity,
      enterpriseName: enterpriseName ?? this.enterpriseName,
      url: url ?? this.url,
      enterpriseId: enterpriseId ?? this.enterpriseId,
      concentradorUrl: concentradorUrl ?? this.concentradorUrl,
      persistApp: persistApp ?? this.persistApp,
      urlCCS: urlCCS ?? this.urlCCS,
      useCovenant: useCovenant ?? this.useCovenant,
      updateDevicesInformations:
          updateDevicesInformations ?? this.updateDevicesInformations,
      updateEnterprise: updateEnterprise ?? this.updateEnterprise,
      serviceChargePercentageOrValue:
          serviceChargePercentageOrValue ?? this.serviceChargePercentageOrValue,
      zoomImage: zoomImage ?? this.zoomImage,
      latestCompatibleVersion:
          latestCompatibleVersion ?? this.latestCompatibleVersion,
      minutesVerifyUpdateMenu:
          minutesVerifyUpdateMenu ?? this.minutesVerifyUpdateMenu,
      useReducedNameOnProduct:
          useReducedNameOnProduct ?? this.useReducedNameOnProduct,
      verifyCommandBlocked: verifyCommandBlocked ?? this.verifyCommandBlocked,
      canInsertCommentManually:
          canInsertCommentManually ?? this.canInsertCommentManually,
      blockUseAppIfIsOutdated:
          blockUseAppIfIsOutdated ?? this.blockUseAppIfIsOutdated,
      canInsertQuantityManually:
          canInsertQuantityManually ?? this.canInsertQuantityManually,
      canInsertCustomer: canInsertCustomer ?? this.canInsertCustomer,
      requestTableNumber: requestTableNumber ?? this.requestTableNumber,
      useOldPrintWay: useOldPrintWay ?? this.useOldPrintWay,
    );
  }

  factory EnterpriseEntity.empty(String enterpriseName) => EnterpriseEntity(
      enterpriseName: enterpriseName,
      url: null,
      enterpriseId: null,
      concentradorUrl: null,
      persistApp: null,
      urlCCS: null,
      useCovenant: null,
      enterpriseConcentradorParametersEntity: null,
      serviceChargePercentageOrValue: null,
      updateDevicesInformations: null,
      updateEnterprise: null,
      zoomImage: null,
      latestCompatibleVersion: null,
      minutesVerifyUpdateMenu: null,
      useReducedNameOnProduct: null,
      verifyCommandBlocked: null,
      canInsertCommentManually: null,
      blockUseAppIfIsOutdated: null,
      canInsertQuantityManually: null,
      canInsertCustomer: null,
      requestTableNumber: null,
      useOldPrintWay: null);
}
