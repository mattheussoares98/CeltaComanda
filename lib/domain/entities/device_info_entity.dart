import 'package:equatable/equatable.dart';

class DeviceInfoEntity extends Equatable {
  final int? commandNumber;
  final DateTime? lastUpdatedDate;
  final String? applicationVersion;
  final String? imei;

  const DeviceInfoEntity({
    required this.commandNumber,
    required this.lastUpdatedDate,
    required this.applicationVersion,
    required this.imei,
  });

  @override
  List<Object?> get props => [
        commandNumber,
        lastUpdatedDate,
        applicationVersion,
        imei,
      ];
}
