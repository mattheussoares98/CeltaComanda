// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

import '../pages.dart';

class UpdateScheduleViewModel extends Equatable {
  final String name;
  final int id;
  final ScheduleType scheduleType;
  final int enterpriseId;
  final ProductScheduleViewModel? productSchedule;
  final ExpansibleGroupScheduleViewModel groupSchedule;

  const UpdateScheduleViewModel({
    required this.name,
    required this.id,
    required this.scheduleType,
    required this.enterpriseId,
    required this.productSchedule,
    required this.groupSchedule,
  });

  @override
  List<Object?> get props => [
        name,
        id,
        scheduleType,
        enterpriseId,
        productSchedule,
        groupSchedule,
      ];
}

extension ScheduleTypeExtension on ScheduleType {
  dynamic get type {
    switch (this) {
      case ScheduleType.product:
        return ProductScheduleViewModel;
      case ScheduleType.child:
        return ProductScheduleViewModel;
      case ScheduleType.expansibleGroup:
        return ExpansibleGroupScheduleViewModel;
    }
  }
}

enum ScheduleType {
  expansibleGroup,
  product,
  child,
}
