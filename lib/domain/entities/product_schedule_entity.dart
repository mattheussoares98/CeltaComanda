

import 'package:equatable/equatable.dart';

class ProductScheduleEntity extends Equatable {
  final int? InternalCodeOnERP;
  final int? EnterpriseId;
  final int? AllowMonday;
  final int? AllowTuesday;
  final int? AllowWednesday;
  final int? AllowThursday;
  final int? AllowFriday;
  final int? AllowSaturday;
  final int? AllowSunday;

  const ProductScheduleEntity({
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
}
