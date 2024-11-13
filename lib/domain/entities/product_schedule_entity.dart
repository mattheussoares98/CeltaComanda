// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

class ProductScheduleEntity extends Equatable {
  final int? InternalCodeOnERP;
  final int? EnterpriseId;
  final int? AllowMonday;
  final int? AlloTuesday;
  final int? AllowWednesday;
  final int? AllowThursday;
  final int? AllowFriday;
  final int? AllowSaturday;
  final int? AllowSunday;

  const ProductScheduleEntity({
    required this.InternalCodeOnERP,
    required this.EnterpriseId,
    required this.AllowMonday,
    required this.AlloTuesday,
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
        AlloTuesday,
        AllowWednesday,
        AllowThursday,
        AllowFriday,
        AllowSaturday,
        AllowSunday,
      ];
}
