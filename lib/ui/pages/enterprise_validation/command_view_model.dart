// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class CommandViewModel extends Equatable {
  final String commandNumber;
  final String isFixedCommandNumber;

  const CommandViewModel({
    required this.commandNumber,
    required this.isFixedCommandNumber,
  });

  factory CommandViewModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll([
      'commandNumber',
      'isFixedCommandNumber',
    ])) {
      throw Exception();
    }
    return CommandViewModel(
      commandNumber: json['commandNumber'],
      isFixedCommandNumber: json['isFixedCommandNumber'],
    );
  }

  factory CommandViewModel.fromEntity(CommandEntity entity) => CommandViewModel(
        commandNumber: entity.commandNumber.toString(),
        isFixedCommandNumber: entity.isFixedCommandNumber.toString(),
      );

  CommandEntity toEntity() => CommandEntity(
        commandNumber: commandNumber,
        isFixedCommandNumber: isFixedCommandNumber == "true",
      );

  Map<String, dynamic> toJson() => {
        "commandNumber": commandNumber,
        "isFixedCommandNumber": isFixedCommandNumber,
      };

  @override
  List<Object?> get props => [commandNumber, isFixedCommandNumber];
}
