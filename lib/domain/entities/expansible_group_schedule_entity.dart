

import 'package:equatable/equatable.dart';

class ExpansibleGroupScheduleEntity extends Equatable {
  final int? ExpansibleGroupId;
  final int? AllowMonday;
  final int? AllowTuesday;
  final int? AllowWednesday;
  final int? AllowThursday;
  final int? AllowFriday;
  final int? AllowSaturday;
  final int? AllowSunday;

  const ExpansibleGroupScheduleEntity({
    required this.ExpansibleGroupId,
    required this.AllowMonday,
    required this.AllowTuesday,
    required this.AllowWednesday,
    required this.AllowThursday,
    required this.AllowFriday,
    required this.AllowSaturday,
    required this.AllowSunday,
  });

  @override
  List<Object?> get props => [
        ExpansibleGroupId,
        AllowMonday,
        AllowTuesday,
        AllowWednesday,
        AllowThursday,
        AllowFriday,
        AllowSaturday,
        AllowSunday,
      ];
}
