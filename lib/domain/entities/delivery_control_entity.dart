import 'package:equatable/equatable.dart';

enum IsToDelivery {
  preparing(1),
  ready(2),
  delivered(3);

  final int value;
  const IsToDelivery(this.value);
}

class DeliveryControlEntity extends Equatable {
  final int Id;
  final int EnterpriseId;
  final int EnterpriseCode;
  final int OriginType;
  final String PersonalizedCode;
  final int? CouponFiscalNumber;
  final DateTime DateOfCreation;
  final DateTime DateHourOfCreation;
  final bool IsCancelled;
  final IsToDelivery isToDelivery;
  final DateTime? DateHourOfDelivery;
  final int? DeliveryControl;
  final int DeliveryStatusLate;
  final double TotalLiquid;

  const DeliveryControlEntity({
    required this.Id,
    required this.EnterpriseId,
    required this.EnterpriseCode,
    required this.OriginType,
    required this.PersonalizedCode,
    required this.CouponFiscalNumber,
    required this.DateOfCreation,
    required this.DateHourOfCreation,
    required this.IsCancelled,
    required this.isToDelivery,
    required this.DateHourOfDelivery,
    required this.DeliveryControl,
    required this.DeliveryStatusLate,
    required this.TotalLiquid,
  });

  @override
  List<Object?> get props => [
        this.Id,
        this.EnterpriseId,
        this.EnterpriseCode,
        this.OriginType,
        this.PersonalizedCode,
        this.CouponFiscalNumber,
        this.DateOfCreation,
        this.DateHourOfCreation,
        this.IsCancelled,
        this.isToDelivery,
        this.DateHourOfDelivery,
        this.DeliveryControl,
        this.DeliveryStatusLate,
        this.TotalLiquid,
      ];
}
