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
  final DeliveryStatusLate deliveryStatusLate;
  final String ProductInternalCode;
  final String ProductName;
  final double Quantity;
  final double ItemValue;
  final int? DeliveryLoteNumber;
  final bool? ProductIsFatherComposition;
  final int? ProductIdOfFather;
  final bool? IsCancelled;
  final String? Comments;
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
    required this.deliveryStatusLate,
    required this.ProductInternalCode,
    required this.ProductName,
    required this.Quantity,
    required this.ItemValue,
    required this.DeliveryLoteNumber,
    required this.ProductIsFatherComposition,
    required this.ProductIdOfFather,
    required this.IsCancelled,
    required this.Comments,
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
        deliveryStatusLate,
        ProductInternalCode,
        ProductName,
        Quantity,
        ItemValue,
        DeliveryLoteNumber,
        ProductIsFatherComposition,
        ProductIdOfFather,
        IsCancelled,
        Comments,
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
    DeliveryStatusLate? deliveryStatusLate,
    String? ProductInternalCode,
    String? ProductName,
    double? Quantity,
    double? ItemValue,
    int? DeliveryLoteNumber,
    bool? ProductIsFatherComposition,
    int? ProductIdOfFather,
    bool? IsCancelled,
    String? Comments,
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
        deliveryStatusLate: deliveryStatusLate ?? this.deliveryStatusLate,
        ProductInternalCode: ProductInternalCode ?? this.ProductInternalCode,
        ProductName: ProductName ?? this.ProductName,
        Quantity: Quantity ?? this.Quantity,
        ItemValue: ItemValue ?? this.ItemValue,
        DeliveryLoteNumber: DeliveryLoteNumber ?? this.DeliveryLoteNumber,
        ProductIsFatherComposition:
            ProductIsFatherComposition ?? this.ProductIsFatherComposition,
        ProductIdOfFather: ProductIdOfFather ?? this.ProductIdOfFather,
        IsCancelled: IsCancelled ?? this.IsCancelled,
        Comments: Comments ?? this.Comments,
        children: children ?? this.children,
      );
}

enum DeliveryStatusLate {
  onTime(1),
  warning(2),
  late(3);

  final int value;
  const DeliveryStatusLate(this.value);

  factory DeliveryStatusLate.fromValue(int value) {
    return DeliveryStatusLate.values.firstWhere(
      (e) => e.value == value,
      orElse: () => DeliveryStatusLate.onTime,
    );
  }
}
