import 'package:equatable/equatable.dart';

class CommandEntity extends Equatable {
  final String? commandNumber;
  final bool isFixedCommandNumber;

  const CommandEntity({
    required this.commandNumber,
    required this.isFixedCommandNumber,
  });

  @override
  List get props => [commandNumber, isFixedCommandNumber];
}
