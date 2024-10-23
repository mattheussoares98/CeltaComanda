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
  final int? updateMenuCount;
  final int? updateEnterpriseCount;
  final EnterpriseConcentradorParametersEntity?
      enterpriseConcentradorParametersEntity;

  const EnterpriseEntity({
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
        updateMenuCount,
        updateEnterpriseCount,
      ];
}
