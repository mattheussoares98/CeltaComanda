// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

class ExpansibleGroupEntity extends Equatable {
  final String Name;
  final int ExpansibleGroupId;
  final int ExpansibleGroupType;
  final int OrderClassification;

  const ExpansibleGroupEntity({
    required this.Name,
    required this.ExpansibleGroupId,
    required this.ExpansibleGroupType,
    required this.OrderClassification,
  });

  @override
  List<Object?> get props => [
        Name,
        ExpansibleGroupId,
        ExpansibleGroupType,
        OrderClassification,
      ];
}
