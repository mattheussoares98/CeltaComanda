import 'package:equatable/equatable.dart';

class ExportChargingEntity extends Equatable {
  final int? EnterpriseId;
  final int? UserId;
  final String? PdvNumber;
  final LoadTypeEnum? LoadType;
  final String? FileName;
  final int? Status;
  final bool? IsAlter;
  final DateTime? Date;

  const ExportChargingEntity({
    required this.EnterpriseId,
    required this.UserId,
    required this.PdvNumber,
    required this.LoadType,
    required this.FileName,
    required this.Status,
    required this.IsAlter,
    required this.Date,
  });

  @override
  List<Object?> get props => [
        EnterpriseId,
        UserId,
        PdvNumber,
        LoadType,
        FileName,
        Status,
        IsAlter,
        Date,
      ];
}

enum LoadTypeEnum {
  images,
  products,
  users,
}
