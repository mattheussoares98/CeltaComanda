

import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class ProductScheduleViewModel extends Equatable {
  final int InternalCodeOnERP;
  final int EnterpriseId;
  final bool AllowMonday;
  final bool AllowTuesday;
  final bool AllowWednesday;
  final bool AllowThursday;
  final bool AllowFriday;
  final bool AllowSaturday;
  final bool AllowSunday;

  const ProductScheduleViewModel({
    required this.InternalCodeOnERP,
    required this.EnterpriseId,
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
        InternalCodeOnERP,
        EnterpriseId,
        AllowMonday,
        AllowTuesday,
        AllowWednesday,
        AllowThursday,
        AllowFriday,
        AllowSaturday,
        AllowSunday,
      ];

  factory ProductScheduleViewModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll([
      'InternalCodeOnERP',
      'EnterpriseId',
    ])) {
      throw Exception();
    }
    return ProductScheduleViewModel(
      InternalCodeOnERP: json["InternalCodeOnERP"],
      EnterpriseId: json["EnterpriseId"],
      AllowMonday: json["AllowMonday"] == 1,
      AllowTuesday: json["AllowTuesday"] == 1,
      AllowWednesday: json["AllowWednesday"] == 1,
      AllowThursday: json["AllowThursday"] == 1,
      AllowFriday: json["AllowFriday"] == 1,
      AllowSaturday: json["AllowSaturday"] == 1,
      AllowSunday: json["AllowSunday"] == 1,
    );
  }

  factory ProductScheduleViewModel.fromEntity(ProductScheduleEntity entity) =>
      ProductScheduleViewModel(
        InternalCodeOnERP: entity.InternalCodeOnERP!,
        EnterpriseId: entity.EnterpriseId!,
        AllowMonday: entity.AllowMonday == 1,
        AllowTuesday: entity.AllowTuesday == 1,
        AllowWednesday: entity.AllowWednesday == 1,
        AllowThursday: entity.AllowThursday == 1,
        AllowFriday: entity.AllowFriday == 1,
        AllowSaturday: entity.AllowSaturday == 1,
        AllowSunday: entity.AllowSunday == 1,
      );

  ProductScheduleEntity toEntity() => ProductScheduleEntity(
        InternalCodeOnERP: InternalCodeOnERP,
        EnterpriseId: EnterpriseId,
        AllowMonday: AllowMonday == true ? 1 : 0,
        AllowTuesday: AllowTuesday == true ? 1 : 0,
        AllowWednesday: AllowWednesday == true ? 1 : 0,
        AllowThursday: AllowThursday == true ? 1 : 0,
        AllowFriday: AllowFriday == true ? 1 : 0,
        AllowSaturday: AllowSaturday == true ? 1 : 0,
        AllowSunday: AllowSunday == true ? 1 : 0,
      );

  Map<String, dynamic> toJson() => {
        "InternalCodeOnERP": InternalCodeOnERP,
        "EnterpriseId": EnterpriseId,
        "AllowMonday": AllowMonday == true ? 1 : 0,
        "AllowTuesday": AllowTuesday == true ? 1 : 0,
        "AllowWednesday": AllowWednesday == true ? 1 : 0,
        "AllowThursday": AllowThursday == true ? 1 : 0,
        "AllowFriday": AllowFriday == true ? 1 : 0,
        "AllowSaturday": AllowSaturday == true ? 1 : 0,
        "AllowSunday": AllowSunday == true ? 1 : 0,
      };
}
