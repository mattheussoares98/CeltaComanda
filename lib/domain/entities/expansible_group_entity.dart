// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

import 'entities.dart';

class ExpansibleGroupEntity extends Equatable {
  final String Name;
  final int ExpansibleGroupId;
  final int ExpansibleGroupType;
  final int OrderClassification;
  final ExpansibleGroupScheduleEntity? Schedule;

  const ExpansibleGroupEntity({
    required this.Name,
    required this.ExpansibleGroupId,
    required this.ExpansibleGroupType,
    required this.OrderClassification,
    required this.Schedule,
  });

  @override
  List<Object?> get props => [
        Name,
        ExpansibleGroupId,
        ExpansibleGroupType,
        OrderClassification,
        Schedule,
      ];
}
