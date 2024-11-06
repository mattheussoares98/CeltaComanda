import 'package:equatable/equatable.dart';

class DeviceInfoEntity extends Equatable {
  final int? commandNumber;
  final String board;
  final String brand;
  final String device;
  final String display;
  final String hardware;
  final String host;
  final String id;
  final String model;

  const DeviceInfoEntity({
    required this.commandNumber,
    required this.board,
    required this.brand,
    required this.device,
    required this.display,
    required this.hardware,
    required this.host,
    required this.id,
    required this.model,
  });

  @override
  List<Object?> get props => [
        commandNumber,
        board,
        brand,
        device,
        display,
        hardware,
        host,
        id,
        model,
      ];
}
