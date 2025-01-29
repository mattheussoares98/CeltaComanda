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
    required this.PdvId,
    required this.PdvNumber,
    required this.IPAddress,
    required this.EnterpriseId,
    required this.MacAddress,
    required this.VersionNumber,
    required this.ParametersJSON,
    required this.UrlSATSharing,
    required this.SATHabilitationType,
    required this.SATHabilitationTypeString,
    required this.SATStatus,
    required this.SATStatusDateHourLastUpdate,
    required this.SATStatusDateHourLastUpdateString,
    required this.IsUsing,
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
