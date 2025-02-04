// ignore_for_file: non_constant_identifier_names

import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';
import '../../../ui/helpers/convert/convert.dart';

class DeviceInfoViewModel extends Equatable {
  final String commandNumber;
  final String lastUpdatedDate;
  final String applicationVersion;
  final String imeiOrWindowsId;
  final String? pdvNumber;

  const DeviceInfoViewModel({
    required this.commandNumber,
    required this.lastUpdatedDate,
    required this.applicationVersion,
    required this.imeiOrWindowsId,
    required this.pdvNumber,
  });

  factory DeviceInfoViewModel.fromEntity(DeviceInfoEntity entity) =>
      DeviceInfoViewModel(
        commandNumber: entity.commandNumber.toString(),
        applicationVersion: entity.applicationVersion.toString(),
        lastUpdatedDate: entity.lastUpdatedDate == null
            ? ""
            : formatDate(
                DateTime.parse(entity.lastUpdatedDate!.toIso8601String()),
                [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn, ':', ss],
              ),
        imeiOrWindowsId: entity.imeiOrWindowsId,
        pdvNumber: entity.pdvNumber,
      );

  factory DeviceInfoViewModel.fromJson(Map data) => DeviceInfoViewModel(
        commandNumber: data['commandNumber'],
        lastUpdatedDate: data['lastUpdatedDate'],
        applicationVersion: data['applicationVersion'],
        imeiOrWindowsId: data['imeiOrWindowsId'],
        pdvNumber: data['pdvNumber'],
      );

  DeviceInfoEntity toEntity() => DeviceInfoEntity(
        commandNumber: commandNumber.toInt(),
        applicationVersion: applicationVersion,
        lastUpdatedDate:
            DateFormat("dd/MM/yyyy HH:mm:ss").parse(lastUpdatedDate),
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

  @override
  List<Object?> get props => [
        commandNumber,
        lastUpdatedDate,
        applicationVersion,
        imeiOrWindowsId,
        pdvNumber,
      ];
}
