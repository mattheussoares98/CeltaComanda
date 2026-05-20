import 'package:equatable/equatable.dart';

import 'delivery_control_entity.dart';

class DeliveryProductControlEntity extends Equatable {
  final DeliveryOriginType OriginType;
  final int Id;
  final int ProductLineId;
  final int EnterpriseId;
  final int EnterpriseCode;
  final String PersonalizedCode;
  final int? CouponFiscalNumber;
  final DateTime DateHourOfCreation;
  final IsToDelivery isToDelivery;
  final DateTime? DateHourOfDelivery;
  final int? DeliveryControl;
  final int DeliveryStatusLate;
  final String ProductInternalCode;
  final String ProductName;
  final double Quantity;
  final double ItemValue;
  final int? DeliveryLoteNumber;
  final bool? ProductIsFatherComposition;
  final int? ProductIdOfFather;

  const DeliveryProductControlEntity({
    required this.OriginType,
    required this.Id,
    required this.ProductLineId,
    required this.EnterpriseId,
    required this.EnterpriseCode,
    required this.PersonalizedCode,
    required this.CouponFiscalNumber,
    required this.DateHourOfCreation,
    required this.isToDelivery,
    required this.DateHourOfDelivery,
    required this.DeliveryControl,
    required this.DeliveryStatusLate,
    required this.ProductInternalCode,
    required this.ProductName,
    required this.Quantity,
    required this.ItemValue,
    required this.DeliveryLoteNumber,
    required this.ProductIsFatherComposition,
    required this.ProductIdOfFather,
  });

  @override
  List<Object?> get props => [
        OriginType,
        Id,
        ProductLineId,
        EnterpriseId,
        EnterpriseCode,
        PersonalizedCode,
        CouponFiscalNumber,
        DateHourOfCreation,
        isToDelivery,
        DateHourOfDelivery,
        DeliveryControl,
        DeliveryStatusLate,
        ProductInternalCode,
        ProductName,
        Quantity,
        ItemValue,
        DeliveryLoteNumber,
        ProductIsFatherComposition,
        ProductIdOfFather,
      ];
}
