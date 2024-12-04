import 'package:equatable/equatable.dart';

class DeviceInfoEntity extends Equatable {
  final int? commandNumber;
  final DateTime? lastUpdatedDate;
  final String? applicationVersion;
  final String imeiOrWindowsId;

  const DeviceInfoEntity({
    required this.commandNumber,
    required this.lastUpdatedDate,
    required this.applicationVersion,
    required this.imeiOrWindowsId,
  });

  @override
  List<Object?> get props => [
        commandNumber,
        lastUpdatedDate,
        applicationVersion,
        imeiOrWindowsId,
      ];
}
