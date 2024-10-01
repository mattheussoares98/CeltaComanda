// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

class CovenantEntity extends Equatable {
  final int Code;
  final int PersonalizedCode;
  final String Name;

  const CovenantEntity({
    required this.Code,
    required this.PersonalizedCode,
    required this.Name,
  });

  @override
  List<Object?> get props => [Code, PersonalizedCode, Name];
}
