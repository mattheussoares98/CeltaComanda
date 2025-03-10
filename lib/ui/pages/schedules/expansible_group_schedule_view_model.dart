

import 'package:equatable/equatable.dart';

import '../../../data/models/models.dart';
import '../../../domain/entities/entities.dart';

class ExpansibleGroupScheduleViewModel extends Equatable {
  final int ExpansibleGroupId;
  final bool AllowMonday;
  final bool AllowTuesday;
  final bool AllowWednesday;
  final bool AllowThursday;
  final bool AllowFriday;
  final bool AllowSaturday;
  final bool AllowSunday;

  const ExpansibleGroupScheduleViewModel({
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

  factory ExpansibleGroupScheduleViewModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll([
      'ExpansibleGroupId',
    ])) {
      throw Exception();
    }
    return ExpansibleGroupScheduleViewModel(
      ExpansibleGroupId: json["ExpansibleGroupId"],
      AllowMonday: json["AllowMonday"] == 1,
      AllowTuesday: json["AllowTuesday"] == 1,
      AllowWednesday: json["AllowWednesday"] == 1,
      AllowThursday: json["AllowThursday"] == 1,
      AllowFriday: json["AllowFriday"] == 1,
      AllowSaturday: json["AllowSaturday"] == 1,
      AllowSunday: json["AllowSunday"] == 1,
    );
  }

  factory ExpansibleGroupScheduleViewModel.fromEntity(
          ExpansibleGroupScheduleEntity entity) =>
      ExpansibleGroupScheduleViewModel(
        ExpansibleGroupId: entity.ExpansibleGroupId!,
        AllowMonday: entity.AllowMonday == 1,
        AllowTuesday: entity.AllowTuesday == 1,
        AllowWednesday: entity.AllowWednesday == 1,
        AllowThursday: entity.AllowThursday == 1,
        AllowFriday: entity.AllowFriday == 1,
        AllowSaturday: entity.AllowSaturday == 1,
        AllowSunday: entity.AllowSunday == 1,
      );

  ExpansibleGroupScheduleEntity toEntity() => ExpansibleGroupScheduleEntity(
        ExpansibleGroupId: ExpansibleGroupId,
        AllowMonday: AllowMonday == true ? 1 : 0,
        AllowTuesday: AllowTuesday == true ? 1 : 0,
        AllowWednesday: AllowWednesday == true ? 1 : 0,
        AllowThursday: AllowThursday == true ? 1 : 0,
        AllowFriday: AllowFriday == true ? 1 : 0,
        AllowSaturday: AllowSaturday == true ? 1 : 0,
        AllowSunday: AllowSunday == true ? 1 : 0,
      );

  ExpansibleGroupScheduleModel toModel() => ExpansibleGroupScheduleModel(
        ExpansibleGroupId: ExpansibleGroupId,
        AllowMonday: AllowMonday,
        AllowTuesday: AllowTuesday,
        AllowWednesday: AllowWednesday,
        AllowThursday: AllowThursday,
        AllowFriday: AllowFriday,
        AllowSaturday: AllowSaturday,
        AllowSunday: AllowSunday,
      );

  Map<String, dynamic> toJson() => {
        "ExpansibleGroupId": ExpansibleGroupId,
        "AllowMonday": AllowMonday == true ? 1 : 0,
        "AllowTuesday": AllowTuesday == true ? 1 : 0,
        "AllowWednesday": AllowWednesday == true ? 1 : 0,
        "AllowThursday": AllowThursday == true ? 1 : 0,
        "AllowFriday": AllowFriday == true ? 1 : 0,
        "AllowSaturday": AllowSaturday == true ? 1 : 0,
        "AllowSunday": AllowSunday == true ? 1 : 0,
      };
}
