// ignore_for_file: non_constant_identifier_names

import '../../domain/entities/entities.dart';

class PdvModel {
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

  const PdvModel({
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

  factory PdvModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll([
      'PdvId',
      'PdvNumber',
      'IPAddress',
    ])) {
      throw Exception();
    }
    return PdvModel(
      PdvId: json["PdvId"],
      PdvNumber: json["PdvNumber"],
      IPAddress: json["IPAddress"],
      EnterpriseId: json["EnterpriseId"],
      MacAddress: json["MacAddress"],
      VersionNumber: json["VersionNumber"],
      ParametersJSON: json["ParametersJSON"],
      UrlSATSharing: json["UrlSATSharing"],
      SATHabilitationType: json["SATHabilitationType"],
      SATHabilitationTypeString: json["SATHabilitationTypeString"],
      SATStatus: json["SATStatus"],
      SATStatusDateHourLastUpdate: json["SATStatusDateHourLastUpdate"],
      SATStatusDateHourLastUpdateString:
          json["SATStatusDateHourLastUpdateString"],
      IsUsing: json["IsUsing"],
    );
  }

  factory PdvModel.fromEntity(PdvEntity entity) => PdvModel(
        PdvId: entity.PdvId,
        PdvNumber: entity.PdvNumber,
        IPAddress: entity.IPAddress,
        EnterpriseId: entity.EnterpriseId,
        MacAddress: entity.MacAddress,
        VersionNumber: entity.VersionNumber,
        ParametersJSON: entity.ParametersJSON,
        UrlSATSharing: entity.UrlSATSharing,
        SATHabilitationType: entity.SATHabilitationType,
        SATHabilitationTypeString: entity.SATHabilitationTypeString,
        SATStatus: entity.SATStatus,
        SATStatusDateHourLastUpdate: entity.SATStatusDateHourLastUpdate,
        SATStatusDateHourLastUpdateString:
            entity.SATStatusDateHourLastUpdateString,
        IsUsing: entity.IsUsing,
      );

  PdvEntity toEntity() => PdvEntity(
        PdvId: PdvId,
        PdvNumber: PdvNumber,
        IPAddress: IPAddress,
        EnterpriseId: EnterpriseId,
        MacAddress: MacAddress,
        VersionNumber: VersionNumber,
        ParametersJSON: ParametersJSON,
        UrlSATSharing: UrlSATSharing,
        SATHabilitationType: SATHabilitationType,
        SATHabilitationTypeString: SATHabilitationTypeString,
        SATStatus: SATStatus,
        SATStatusDateHourLastUpdate: SATStatusDateHourLastUpdate,
        SATStatusDateHourLastUpdateString: SATStatusDateHourLastUpdateString,
        IsUsing: IsUsing,
      );

  Map<String, dynamic> toJson() => {
        "PdvId": PdvId,
        "PdvNumber": PdvNumber,
        "IPAddress": IPAddress,
        "EnterpriseId": EnterpriseId,
        "MacAddress": MacAddress,
        "VersionNumber": VersionNumber,
        "ParametersJSON": ParametersJSON,
        "UrlSATSharing": UrlSATSharing,
        "SATHabilitationType": SATHabilitationType,
        "SATHabilitationTypeString": SATHabilitationTypeString,
        "SATStatus": SATStatus,
        "SATStatusDateHourLastUpdate": SATStatusDateHourLastUpdate,
        "SATStatusDateHourLastUpdateString": SATStatusDateHourLastUpdateString,
        "IsUsing": IsUsing,
      };
}
