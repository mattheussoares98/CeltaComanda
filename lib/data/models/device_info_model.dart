// ignore_for_file: non_constant_identifier_names

import '../../domain/entities/entities.dart';

class DeviceInfoModel {
  final int? commandNumber;
  final String? imei;
  final String? lastUpdatedDate;
  final String? applicationVersion;

  const DeviceInfoModel({
    required this.commandNumber,
    required this.imei,
    required this.lastUpdatedDate,
    required this.applicationVersion,
  });

  factory DeviceInfoModel.fromEntity(DeviceInfoEntity entity) =>
      DeviceInfoModel(
        commandNumber: entity.commandNumber,
        applicationVersion: entity.applicationVersion,
        lastUpdatedDate: entity.lastUpdatedDate?.toIso8601String(),
        imei: entity.imei,
      );

  DeviceInfoEntity toEntity() => DeviceInfoEntity(
        commandNumber: commandNumber,
        imei: imei,
        applicationVersion: applicationVersion,
        lastUpdatedDate:
            lastUpdatedDate != null ? DateTime.parse(lastUpdatedDate!) : null,
      );

  Map<String, dynamic> toJson() => {
        "commandNumber": commandNumber,
        "imei": imei,
        "lastUpdatedDate": lastUpdatedDate,
        "applicationVersion": applicationVersion,
      };
}
