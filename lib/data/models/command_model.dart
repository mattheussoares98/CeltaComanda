// ignore_for_file: non_constant_identifier_names

import '../../domain/entities/entities.dart';
import 'models.dart';

class CommandModel {
  final String? commandNumber;
  final bool isFixedCommandNumber;
  final PdvModel? pdv;
  CommandModel({
    required this.commandNumber,
    required this.isFixedCommandNumber,
    required this.pdv,
  });

  factory CommandModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll([
      'commandNumber',
      'isFixedCommandNumber',
    ])) {
      throw Exception();
    }
    return CommandModel(
      commandNumber: json['commandNumber'] == "" ? null : json['commandNumber'],
      isFixedCommandNumber: json['isFixedCommandNumber'],
      pdv: json['pdv'],
    );
  }

  factory CommandModel.fromEntity(CommandEntity entity) => CommandModel(
        commandNumber: entity.commandNumber,
        isFixedCommandNumber: entity.isFixedCommandNumber,
        pdv: entity.pdv == null ? null : PdvModel.fromEntity(entity.pdv!),
      );

  CommandEntity toEntity() => CommandEntity(
        commandNumber: commandNumber,
        isFixedCommandNumber: isFixedCommandNumber,
        pdv: pdv?.toEntity(),
      );

  Map<String, dynamic> toJson() => {
        "commandNumber": commandNumber,
        "isFixedCommandNumber": isFixedCommandNumber,
        "pdv": pdv,
      };
}
