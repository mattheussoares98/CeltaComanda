// ignore_for_file: public_member_api_docs, sort_constructors_first

import '../../../domain/entities/entities.dart';
import 'delivery_product_control_model.dart';

class DeliveryControlModel extends DeliveryControlEntity {
  const DeliveryControlModel({
    required super.Id,
    required super.EnterpriseId,
    required super.EnterpriseCode,
    required super.OriginType,
    required super.PersonalizedCode,
    required super.CouponFiscalNumber,
    required super.DateOfCreation,
    required super.DateHourOfCreation,
    required super.IsCancelled,
    required super.isToDelivery,
    required super.DateHourOfDelivery,
    required super.DeliveryControl,
    required super.deliveryStatusLate,
    required super.TotalLiquid,
    super.Products,
  });

  @override
  List<Object?> get props => [
        super.Id,
        super.EnterpriseId,
        super.EnterpriseCode,
        super.OriginType,
        super.PersonalizedCode,
        super.CouponFiscalNumber,
        super.DateOfCreation,
        super.DateHourOfCreation,
        super.IsCancelled,
        super.isToDelivery,
        super.DateHourOfDelivery,
        super.DeliveryControl,
        super.deliveryStatusLate,
        super.TotalLiquid,
        super.Products,
      ];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'Id': Id,
      'EnterpriseId': EnterpriseId,
      'EnterpriseCode': EnterpriseCode,
      'OriginType': OriginType.value,
      'PersonalizedCode': PersonalizedCode,
      'CouponFiscalNumber': CouponFiscalNumber,
      'DateOfCreation': DateOfCreation.millisecondsSinceEpoch,
      'DateHourOfCreation': DateHourOfCreation.millisecondsSinceEpoch,
      'IsCancelled': IsCancelled,
      'IsToDelivery': isToDelivery,
      'DateHourOfDelivery': DateHourOfDelivery?.millisecondsSinceEpoch,
      'DeliveryControl': DeliveryControl,
      'DeliveryStatusLate': deliveryStatusLate,
      'TotalLiquid': TotalLiquid,
      'Products':
          Products?.map((x) => (x as DeliveryProductControlModel).toJson())
              .toList(),
    };
  }

  factory DeliveryControlModel.fromJson(Map<String, dynamic> map) {
    return DeliveryControlModel(
      Id: map['Id'] as int,
      EnterpriseId: map['EnterpriseId'] as int,
      EnterpriseCode: map['EnterpriseCode'] as int,
      OriginType: DeliveryOriginType.fromValue(map['OriginType'] as int),
      PersonalizedCode: map['PersonalizedCode'] as String,
      CouponFiscalNumber: map['CouponFiscalNumber'] != null
          ? map['CouponFiscalNumber'] as int
          : null,
      DateOfCreation: DateTime.parse(map['DateOfCreation']),
      DateHourOfCreation: DateTime.parse(map['DateHourOfCreation']),
      IsCancelled: map['IsCancelled'] as bool,
      isToDelivery: IsToDelivery.fromValue(map['IsToDelivery'] as int),
      DateHourOfDelivery: map['DateHourOfDelivery'] != null
          ? DateTime.parse(map['DateHourOfDelivery'])
          : null,
      DeliveryControl:
          map['DeliveryControl'] != null ? map['DeliveryControl'] as int : null,
      deliveryStatusLate:
          DeliveryStatusLate.fromValue(map['DeliveryStatusLate'] as int),
      TotalLiquid: (map['TotalLiquid'] as num).toDouble(),
      Products: (map['Products'] as List?)
          ?.map((e) => DeliveryProductControlModel.fromJson(e))
          .toList(),
    );
  }

  factory DeliveryControlModel.fromEntity(DeliveryControlEntity entity) =>
      DeliveryControlModel(
        Id: entity.Id,
        EnterpriseId: entity.EnterpriseId,
        EnterpriseCode: entity.EnterpriseCode,
        OriginType: entity.OriginType,
        PersonalizedCode: entity.PersonalizedCode,
        CouponFiscalNumber: entity.CouponFiscalNumber,
        DateOfCreation: entity.DateOfCreation,
        DateHourOfCreation: entity.DateHourOfCreation,
        IsCancelled: entity.IsCancelled,
        isToDelivery: entity.isToDelivery,
        DateHourOfDelivery: entity.DateHourOfDelivery,
        DeliveryControl: entity.DeliveryControl,
        deliveryStatusLate: entity.deliveryStatusLate,
        TotalLiquid: entity.TotalLiquid,
        Products: entity.Products?.map(
            (e) => DeliveryProductControlModel.fromEntity(e)).toList(),
      );

  DeliveryControlEntity toEntity() => DeliveryControlEntity(
        Id: Id,
        EnterpriseId: EnterpriseId,
        EnterpriseCode: EnterpriseCode,
        OriginType: OriginType,
        PersonalizedCode: PersonalizedCode,
        CouponFiscalNumber: CouponFiscalNumber,
        DateOfCreation: DateOfCreation,
        DateHourOfCreation: DateHourOfCreation,
        IsCancelled: IsCancelled,
        isToDelivery: isToDelivery,
        DateHourOfDelivery: DateHourOfDelivery,
        DeliveryControl: DeliveryControl,
        deliveryStatusLate: deliveryStatusLate,
        TotalLiquid: TotalLiquid,
        Products:
            Products?.map((e) => (e as DeliveryProductControlModel).toEntity())
                .toList(),
      );
}
