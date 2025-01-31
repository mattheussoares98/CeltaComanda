import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class ExportChargingModel extends Equatable {
  final int? EnterpriseId;
  final int? UserId;
  final String? PdvNumber;
  final LoadTypeEnum? LoadType;
  final String? FileName;
  final int? Status;
  final bool? IsAlter;
  final DateTime? Date;

  const ExportChargingModel({
    required this.EnterpriseId,
    required this.UserId,
    required this.PdvNumber,
    required this.LoadType,
    required this.FileName,
    required this.Status,
    required this.IsAlter,
    required this.Date,
  });

  @override
  List<Object?> get props => [
        EnterpriseId,
        UserId,
        PdvNumber,
        LoadType,
        FileName,
        Status,
        IsAlter,
        Date,
      ];

  factory ExportChargingModel.fromJson(Map json) => ExportChargingModel(
        EnterpriseId: json['EnterpriseId'],
        UserId: json['UserId'],
        PdvNumber: json['PdvNumber'],
        LoadType: _treatLoadType(json['LoadType']),
        FileName: json['FileName'],
        Status: json['Status'],
        IsAlter: json['IsAlter'],
        Date: json['Date'] == null ? null : DateTime.parse(json['Date']),
      );

  Map<String, dynamic> toJson() => {
        'EnterpriseId': EnterpriseId,
        'UserId': UserId,
        'PdvNumber': PdvNumber,
        'LoadType': LoadType,
        'FileName': FileName,
        'Status': Status,
        'IsAlter': IsAlter,
        'Date': Date,
      };

  factory ExportChargingModel.fromEntity(ExportChargingEntity entity) =>
      ExportChargingModel(
        EnterpriseId: entity.EnterpriseId,
        UserId: entity.UserId,
        PdvNumber: entity.PdvNumber,
        LoadType: entity.LoadType,
        FileName: entity.FileName,
        Status: entity.Status,
        IsAlter: entity.IsAlter,
        Date: entity.Date,
      );

  ExportChargingEntity toEntity() => ExportChargingEntity(
        EnterpriseId: EnterpriseId,
        UserId: UserId,
        PdvNumber: PdvNumber,
        LoadType: LoadType,
        FileName: FileName,
        Status: Status,
        IsAlter: IsAlter,
        Date: Date,
      );

  static LoadTypeEnum? _treatLoadType(String? loadType) {
    if (loadType == null) {
      return null;
    } else if (loadType.toLowerCase() ==
        LoadTypeEnum.images.name.toLowerCase()) {
      return LoadTypeEnum.images;
    } else if (loadType.toLowerCase() ==
            "expansibleGroupProducts".toLowerCase() ||
        loadType.toLowerCase() == "expansibleGroups".toLowerCase() ||
        loadType.toLowerCase() == "productCompositions".toLowerCase() ||
        loadType.toLowerCase() == "products".toLowerCase() ||
        loadType.toLowerCase() == "schedule".toLowerCase()) {
      return LoadTypeEnum.products;
    } else {
      return null;
    }
  }
}
