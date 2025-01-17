// ignore_for_file: non_constant_identifier_names

import '../../domain/entities/entities.dart';

class DeviceInfoModel {
  final int? commandNumber;
  final String? lastUpdatedDate;
  final String? applicationVersion;
  final String imeiOrWindowsId;

  const DeviceInfoModel({
    required this.commandNumber,
    required this.lastUpdatedDate,
    required this.applicationVersion,
    required this.imeiOrWindowsId,
  });

  factory DeviceInfoModel.fromEntity(DeviceInfoEntity entity) =>
      DeviceInfoModel(
        commandNumber: entity.commandNumber,
        applicationVersion: entity.applicationVersion,
        lastUpdatedDate: entity.lastUpdatedDate?.toIso8601String(),
        imeiOrWindowsId: entity.imeiOrWindowsId,
      );

  factory DeviceInfoModel.fromJson(Map data) => DeviceInfoModel(
        commandNumber: data['commandNumber'],
        lastUpdatedDate: data['lastUpdatedDate'],
        applicationVersion: data['applicationVersion'],
        imeiOrWindowsId: data['imeiOrWindowsId'] ?? "",
      );

  DeviceInfoEntity toEntity() => DeviceInfoEntity(
        commandNumber: commandNumber,
        applicationVersion: applicationVersion,
        lastUpdatedDate:
            lastUpdatedDate != null ? DateTime.parse(lastUpdatedDate!) : null,
        imeiOrWindowsId: imeiOrWindowsId,
      );

  Map<String, dynamic> toJson() => {
        "commandNumber": commandNumber,
        "lastUpdatedDate": lastUpdatedDate,
        "applicationVersion": applicationVersion,
        "imeiOrWindowsId": imeiOrWindowsId,
      };
}
