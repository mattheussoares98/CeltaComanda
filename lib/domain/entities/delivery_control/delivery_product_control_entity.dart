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
  final List<DeliveryProductControlEntity>? children;

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
    required this.children,
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
        children,
      ];

  DeliveryProductControlEntity copyWith({
    DeliveryOriginType? OriginType,
    int? Id,
    int? ProductLineId,
    int? EnterpriseId,
    int? EnterpriseCode,
    String? PersonalizedCode,
    int? CouponFiscalNumber,
    DateTime? DateHourOfCreation,
    IsToDelivery? isToDelivery,
    DateTime? DateHourOfDelivery,
    int? DeliveryControl,
    int? DeliveryStatusLate,
    String? ProductInternalCode,
    String? ProductName,
    double? Quantity,
    double? ItemValue,
    int? DeliveryLoteNumber,
    bool? ProductIsFatherComposition,
    int? ProductIdOfFather,
    List<DeliveryProductControlEntity>? children,
  }) =>
      DeliveryProductControlEntity(
        OriginType: OriginType ?? this.OriginType,
        Id: Id ?? this.Id,
        ProductLineId: ProductLineId ?? this.ProductLineId,
        EnterpriseId: EnterpriseId ?? this.EnterpriseId,
        EnterpriseCode: EnterpriseCode ?? this.EnterpriseCode,
        PersonalizedCode: PersonalizedCode ?? this.PersonalizedCode,
        CouponFiscalNumber: CouponFiscalNumber ?? this.CouponFiscalNumber,
        DateHourOfCreation: DateHourOfCreation ?? this.DateHourOfCreation,
        isToDelivery: isToDelivery ?? this.isToDelivery,
        DateHourOfDelivery: DateHourOfDelivery ?? this.DateHourOfDelivery,
        DeliveryControl: DeliveryControl ?? this.DeliveryControl,
        DeliveryStatusLate: DeliveryStatusLate ?? this.DeliveryStatusLate,
        ProductInternalCode: ProductInternalCode ?? this.ProductInternalCode,
        ProductName: ProductName ?? this.ProductName,
        Quantity: Quantity ?? this.Quantity,
        ItemValue: ItemValue ?? this.ItemValue,
        DeliveryLoteNumber: DeliveryLoteNumber ?? this.DeliveryLoteNumber,
        ProductIsFatherComposition:
            ProductIsFatherComposition ?? this.ProductIsFatherComposition,
        ProductIdOfFather: ProductIdOfFather ?? this.ProductIdOfFather,
        children: children ?? this.children,
      );
}
