// ignore_for_file: non_constant_identifier_names

import '../../domain/entities/entities.dart';

class CommandModel {
  final String? commandNumber;
  final bool isFixedCommandNumber;
  CommandModel({
    required this.commandNumber,
    required this.isFixedCommandNumber,
  });

  factory CommandModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll([
      'commandNumber',
      'isFixedCommandNumber',
    ])) {
      throw Exception();
    }
    return CommandModel(
      commandNumber: json['commandNumber'],
      isFixedCommandNumber: json['isFixedCommandNumber'],
    );
  }

  factory CommandModel.fromEntity(CommandEntity entity) => CommandModel(
        commandNumber: entity.commandNumber,
        isFixedCommandNumber: entity.isFixedCommandNumber,
      );

  CommandEntity toEntity() => CommandEntity(
        commandNumber: commandNumber,
        isFixedCommandNumber: isFixedCommandNumber,
      );

  Map<String, dynamic> toJson() => {
        "commandNumber": commandNumber,
        "isFixedCommandNumber": isFixedCommandNumber,
      };
}
