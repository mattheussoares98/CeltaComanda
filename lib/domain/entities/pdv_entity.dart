// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

class PdvEntity extends Equatable {
  final int? PdvId;
  final String? PdvNumber;
  final String? IPAddress;
  final int? EnterpriseId;
  final String? MacAddress;
  final String? VersionNumber;
  final String? ParametersJSON;
  final String? UrlSATSharing;
  final int? SATHabilitationType;
  final String? SATHabilitationTypeString;
  final String? SATStatus;
  final String? SATStatusDateHourLastUpdate;
  final String? SATStatusDateHourLastUpdateString;
  final bool? IsUsing;

  const PdvEntity({
    this.PdvId,
    this.PdvNumber,
    this.IPAddress,
    this.EnterpriseId,
    this.MacAddress,
    this.VersionNumber,
    this.ParametersJSON,
    this.UrlSATSharing,
    this.SATHabilitationType,
    this.SATHabilitationTypeString,
    this.SATStatus,
    this.SATStatusDateHourLastUpdate,
    this.SATStatusDateHourLastUpdateString,
    this.IsUsing,
  });

  @override
  List get props => [
        PdvId,
        PdvNumber,
        IPAddress,
        EnterpriseId,
        MacAddress,
        VersionNumber,
        ParametersJSON,
        UrlSATSharing,
        SATHabilitationType,
        SATHabilitationTypeString,
        SATStatus,
        SATStatusDateHourLastUpdate,
        SATStatusDateHourLastUpdateString,
        IsUsing,
      ];
}
