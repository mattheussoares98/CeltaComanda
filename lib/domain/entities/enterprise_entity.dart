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
      ];
}
