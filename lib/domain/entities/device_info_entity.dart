import 'package:equatable/equatable.dart';

class DeviceInfoEntity extends Equatable {
  final int? commandNumber;
  final String appName;
  final String packageName;
  final String version;
  final String buildNumber;

  const DeviceInfoEntity({
    required this.commandNumber,
    required this.appName,
    required this.packageName,
    required this.version,
    required this.buildNumber,
  });

  @override
  List<Object?> get props => [
        commandNumber,
        appName,
        packageName,
        version,
        buildNumber,
      ];
}
