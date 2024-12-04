import 'package:equatable/equatable.dart';

import 'entities.dart';

class CommandEntity extends Equatable {
  final String? commandNumber;
  final bool isFixedCommandNumber;
  final PdvEntity? pdv;

  const CommandEntity({
    required this.commandNumber,
    required this.isFixedCommandNumber,
    required this.pdv,
  });

  @override
  List get props => [
        commandNumber,
        isFixedCommandNumber,
        pdv,
      ];
}
