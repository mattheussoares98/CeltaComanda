import 'package:equatable/equatable.dart';

class DeviceInfoEntity extends Equatable {
  final int? commandNumber;
  final DateTime? lastUpdatedDate;
  final String? applicationVersion;

  const DeviceInfoEntity({
    required this.commandNumber,
    required this.lastUpdatedDate,
    required this.applicationVersion,
  });

  @override
  List<Object?> get props => [
        commandNumber,
        lastUpdatedDate,
        applicationVersion,
      ];
}
