// ignore_for_file: non_constant_identifier_names

import '../../domain/entities/entities.dart';

class DeviceInfoModel {
  final int? commandNumber;
  final String? lastUpdatedDate;
  final String? applicationVersion;
  final String imeiOrWindowsId;
  final String? pdvNumber;

  const DeviceInfoModel({
    required this.commandNumber,
    required this.lastUpdatedDate,
    required this.applicationVersion,
    required this.imeiOrWindowsId,
    required this.pdvNumber,
  });

  factory DeviceInfoModel.fromEntity(DeviceInfoEntity entity) =>
      DeviceInfoModel(
        commandNumber: entity.commandNumber,
        applicationVersion: entity.applicationVersion,
        lastUpdatedDate: entity.lastUpdatedDate?.toIso8601String(),
        imeiOrWindowsId: entity.imeiOrWindowsId,
        pdvNumber: entity.pdvNumber,
      );

  factory DeviceInfoModel.fromJson(Map data) => DeviceInfoModel(
        commandNumber: data['commandNumber'],
        lastUpdatedDate: data['lastUpdatedDate'],
        applicationVersion: data['applicationVersion'],
        imeiOrWindowsId: data['imeiOrWindowsId'] ?? "",
        pdvNumber: data['pdvNumber'],
      );

  DeviceInfoEntity toEntity() => DeviceInfoEntity(
        commandNumber: commandNumber,
        applicationVersion: applicationVersion,
        lastUpdatedDate:
            lastUpdatedDate != null ? DateTime.parse(lastUpdatedDate!) : null,
        imeiOrWindowsId: imeiOrWindowsId,
        pdvNumber: pdvNumber,
      );

  Map<String, dynamic> toJson() => {
        "commandNumber": commandNumber,
        "lastUpdatedDate": lastUpdatedDate,
        "applicationVersion": applicationVersion,
        "imeiOrWindowsId": imeiOrWindowsId,
        "pdvNumber": pdvNumber,
      };
}
