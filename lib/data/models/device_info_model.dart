// ignore_for_file: non_constant_identifier_names

import '../../domain/entities/entities.dart';

class DeviceInfoModel {
  final int? commandNumber;
  final String board;
  final String brand;
  final String device;
  final String display;
  final String hardware;
  final String host;
  final String id;
  final String model;

  const DeviceInfoModel({
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

  factory DeviceInfoModel.fromJson(Map json, int? commandNumber) {
    return DeviceInfoModel(
      commandNumber: commandNumber,
      board: json["board"],
      brand: json["brand"],
      device: json["device"],
      display: json["display"],
      hardware: json["hardware"],
      host: json["host"],
      id: json["id"],
      model: json["model"],
    );
  }

  factory DeviceInfoModel.fromEntity(DeviceInfoEntity entity) =>
      DeviceInfoModel(
        commandNumber: entity.commandNumber,
        board: entity.board,
        brand: entity.brand,
        device: entity.device,
        display: entity.display,
        hardware: entity.hardware,
        host: entity.host,
        id: entity.id,
        model: entity.model,
      );

  DeviceInfoEntity toEntity() => DeviceInfoEntity(
        commandNumber: commandNumber,
        board: board,
        brand: brand,
        device: device,
        display: display,
        hardware: hardware,
        host: host,
        id: id,
        model: model,
      );

  Map<String, dynamic> toJson() => {
        "commandNumber": commandNumber,
        "board": board,
        "brand": brand,
        "device": device,
        "display": display,
        "hardware": hardware,
        "host": host,
        "id": id,
        "model": model,
      };
}
