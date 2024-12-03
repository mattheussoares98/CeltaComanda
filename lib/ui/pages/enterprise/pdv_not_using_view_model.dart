// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:equatable/equatable.dart';

import '../../../ui/helpers/helpers.dart';
import '../../../domain/entities/entities.dart';

class PdvNotUsingViewModel extends Equatable {
  final String PdvId;
  final String PdvNumber;
  final String IPAddress;
  final String EnterpriseId;
  final String MacAddress;
  final String VersionNumber;
  final String ParametersJSON;
  final String UrlSATSharing;
  final String SATHabilitationType;
  final String SATHabilitationTypeString;
  final String SATStatus;
  final String SATStatusDateHourLastUpdate;
  final String SATStatusDateHourLastUpdateString;
  final String IsUsing;

  const PdvNotUsingViewModel({
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

  factory PdvNotUsingViewModel.fromEntity(PdvEntity entity) =>
      PdvNotUsingViewModel(
        PdvId: entity.PdvId.toString(),
        PdvNumber: entity.PdvNumber.toString(),
        IPAddress: entity.IPAddress.toString(),
        EnterpriseId: entity.EnterpriseId.toString(),
        MacAddress: entity.MacAddress.toString(),
        VersionNumber: entity.VersionNumber.toString(),
        ParametersJSON: entity.ParametersJSON.toString(),
        UrlSATSharing: entity.UrlSATSharing.toString(),
        SATHabilitationType: entity.SATHabilitationType.toString(),
        SATHabilitationTypeString: entity.SATHabilitationTypeString.toString(),
        SATStatus: entity.SATStatus.toString(),
        SATStatusDateHourLastUpdate:
            entity.SATStatusDateHourLastUpdate.toString(),
        SATStatusDateHourLastUpdateString:
            entity.SATStatusDateHourLastUpdateString.toString(),
        IsUsing: entity.IsUsing.toString(),
      );

  PdvEntity toEntity() => PdvEntity(
        PdvId: PdvId.toInt(),
        PdvNumber: PdvNumber,
        IPAddress: IPAddress,
        EnterpriseId: EnterpriseId.toInt(),
        MacAddress: MacAddress,
        VersionNumber: VersionNumber,
        ParametersJSON: ParametersJSON,
        UrlSATSharing: UrlSATSharing,
        SATHabilitationType: SATHabilitationType.toInt(),
        SATHabilitationTypeString: SATHabilitationTypeString,
        SATStatus: SATStatus,
        SATStatusDateHourLastUpdate: SATStatusDateHourLastUpdate,
        SATStatusDateHourLastUpdateString: SATStatusDateHourLastUpdateString,
        IsUsing: IsUsing == "true",
      );

  @override
  List<Object?> get props => [
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
