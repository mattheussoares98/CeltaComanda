import 'package:equatable/equatable.dart';

class CrossIdEntity extends Equatable {
  final String crossId;

  @override
  List get props => [crossId];

  const CrossIdEntity({required this.crossId});
}
