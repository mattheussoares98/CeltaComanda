import 'package:equatable/equatable.dart';

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
  final int IsToDelivery;
  final DateTime? DateHourOfDelivery;
  final int? DeliveryControl;
  final int DeliveryStatusLate;

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
    required this.IsToDelivery,
    required this.DateHourOfDelivery,
    required this.DeliveryControl,
    required this.DeliveryStatusLate,
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
        this.IsToDelivery,
        this.DateHourOfDelivery,
        this.DeliveryControl,
        this.DeliveryStatusLate,
      ];
}
