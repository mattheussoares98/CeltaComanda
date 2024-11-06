// ignore_for_file: non_constant_identifier_names

import '../../domain/entities/entities.dart';

class DeviceInfoModel {
  final int? commandNumber;
  final String appName;
  final String packageName;
  final String version;
  final String buildNumber;

  const DeviceInfoModel({
    required this.commandNumber,
    required this.appName,
    required this.packageName,
    required this.version,
    required this.buildNumber,
  });

  factory DeviceInfoModel.fromJson(Map json) {
    return DeviceInfoModel(
      commandNumber: json["commandNumber"],
      appName: json["appName"],
      packageName: json["packageName"],
      version: json["version"],
      buildNumber: json["buildNumber"],
    );
  }

  factory DeviceInfoModel.fromEntity(DeviceInfoEntity entity) =>
      DeviceInfoModel(
        commandNumber: entity.commandNumber,
        appName: entity.appName,
        packageName: entity.packageName,
        version: entity.version,
        buildNumber: entity.buildNumber,
      );

  DeviceInfoEntity toEntity() => DeviceInfoEntity(
        commandNumber: commandNumber,
        appName: appName,
        packageName: packageName,
        version: version,
        buildNumber: buildNumber,
      );

  Map<String, dynamic> toJson() => {
        "commandNumber": commandNumber,
        "appName": appName,
        "packageName": packageName,
        "version": version,
        "buildNumber": buildNumber,
      };
}
