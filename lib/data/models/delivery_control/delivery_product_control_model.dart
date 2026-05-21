// ignore_for_file: public_member_api_docs, sort_constructors_first

import '../../../domain/entities/entities.dart';

class DeliveryProductControlModel extends DeliveryProductControlEntity {
  const DeliveryProductControlModel({
    required super.OriginType,
    required super.Id,
    required super.ProductLineId,
    required super.EnterpriseId,
    required super.EnterpriseCode,
    required super.PersonalizedCode,
    required super.CouponFiscalNumber,
    required super.DateHourOfCreation,
    required super.isToDelivery,
    required super.DateHourOfDelivery,
    required super.DeliveryControl,
    required super.DeliveryStatusLate,
    required super.ProductInternalCode,
    required super.ProductName,
    required super.Quantity,
    required super.ItemValue,
    required super.DeliveryLoteNumber,
    required super.ProductIsFatherComposition,
    required super.ProductIdOfFather,
    required super.children,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'OriginType': OriginType.value,
      'Id': Id,
      'ProductLineId': ProductLineId,
      'EnterpriseId': EnterpriseId,
      'EnterpriseCode': EnterpriseCode,
      'PersonalizedCode': PersonalizedCode,
      'CouponFiscalNumber': CouponFiscalNumber,
      'DateHourOfCreation': DateHourOfCreation.millisecondsSinceEpoch,
      'IsToDelivery': isToDelivery.index,
      'DateHourOfDelivery': DateHourOfDelivery?.millisecondsSinceEpoch,
      'DeliveryControl': DeliveryControl,
      'DeliveryStatusLate': DeliveryStatusLate,
      'ProductInternalCode': ProductInternalCode,
      'ProductName': ProductName,
      'Quantity': Quantity,
      'ItemValue': ItemValue,
      'DeliveryLoteNumber': DeliveryLoteNumber,
      'ProductIsFatherComposition': ProductIsFatherComposition,
      'ProductIdOfFather': ProductIdOfFather,
      'Children': children
          ?.map((x) => (x as DeliveryProductControlModel).toJson())
          .toList(),
    };
  }

  factory DeliveryProductControlModel.fromJson(Map<String, dynamic> map) {
    return DeliveryProductControlModel(
      OriginType: DeliveryOriginType.fromValue(map['OriginType'] as int),
      Id: map['Id'] as int,
      ProductLineId: map['ProductLineId'] as int,
      EnterpriseId: map['EnterpriseId'] as int,
      EnterpriseCode: map['EnterpriseCode'] as int,
      PersonalizedCode: map['PersonalizedCode'] as String,
      CouponFiscalNumber: map['CouponFiscalNumber'] != null
          ? map['CouponFiscalNumber'] as int
          : null,
      DateHourOfCreation: map['DateHourOfCreation'] is int
          ? DateTime.fromMillisecondsSinceEpoch(
              map['DateHourOfCreation'] as int)
          : DateTime.parse(map['DateHourOfCreation'].toString()),
      isToDelivery: map['IsToDelivery'] is int
          ? IsToDelivery.values.firstWhere(
              (e) => e.value == map['IsToDelivery'],
              orElse: () => IsToDelivery.values[map['IsToDelivery'] as int],
            )
          : IsToDelivery.preparing,
      DateHourOfDelivery: map['DateHourOfDelivery'] != null
          ? (map['DateHourOfDelivery'] is int
              ? DateTime.fromMillisecondsSinceEpoch(
                  map['DateHourOfDelivery'] as int)
              : DateTime.parse(map['DateHourOfDelivery'].toString()))
          : null,
      DeliveryControl:
          map['DeliveryControl'] != null ? map['DeliveryControl'] as int : null,
      DeliveryStatusLate: map['DeliveryStatusLate'] as int,
      ProductInternalCode: map['ProductInternalCode'] as String,
      ProductName: map['ProductName'] as String,
      Quantity: (map['Quantity'] as num).toDouble(),
      ItemValue: (map['ItemValue'] as num).toDouble(),
      DeliveryLoteNumber: map['DeliveryLoteNumber'] != null
          ? map['DeliveryLoteNumber'] as int
          : null,
      ProductIsFatherComposition: map['ProductIsFatherComposition'] != null
          ? map['ProductIsFatherComposition'] as bool
          : null,
      ProductIdOfFather: map['ProductIdOfFather'] != null
          ? map['ProductIdOfFather'] as int
          : null,
      children: map['Children'] != null
          ? (map['Children'] as List)
              .map((x) => DeliveryProductControlModel.fromJson(x))
              .toList()
          : null,
    );
  }

  factory DeliveryProductControlModel.fromEntity(
          DeliveryProductControlEntity entity) =>
      DeliveryProductControlModel(
        OriginType: entity.OriginType,
        Id: entity.Id,
        ProductLineId: entity.ProductLineId,
        EnterpriseId: entity.EnterpriseId,
        EnterpriseCode: entity.EnterpriseCode,
        PersonalizedCode: entity.PersonalizedCode,
        CouponFiscalNumber: entity.CouponFiscalNumber,
        DateHourOfCreation: entity.DateHourOfCreation,
        isToDelivery: entity.isToDelivery,
        DateHourOfDelivery: entity.DateHourOfDelivery,
        DeliveryControl: entity.DeliveryControl,
        DeliveryStatusLate: entity.DeliveryStatusLate,
        ProductInternalCode: entity.ProductInternalCode,
        ProductName: entity.ProductName,
        Quantity: entity.Quantity,
        ItemValue: entity.ItemValue,
        DeliveryLoteNumber: entity.DeliveryLoteNumber,
        ProductIsFatherComposition: entity.ProductIsFatherComposition,
        ProductIdOfFather: entity.ProductIdOfFather,
        children: entity.children,
      );

  DeliveryProductControlEntity toEntity() => DeliveryProductControlEntity(
        OriginType: OriginType,
        Id: Id,
        ProductLineId: ProductLineId,
        EnterpriseId: EnterpriseId,
        EnterpriseCode: EnterpriseCode,
        PersonalizedCode: PersonalizedCode,
        CouponFiscalNumber: CouponFiscalNumber,
        DateHourOfCreation: DateHourOfCreation,
        isToDelivery: isToDelivery,
        DateHourOfDelivery: DateHourOfDelivery,
        DeliveryControl: DeliveryControl,
        DeliveryStatusLate: DeliveryStatusLate,
        ProductInternalCode: ProductInternalCode,
        ProductName: ProductName,
        Quantity: Quantity,
        ItemValue: ItemValue,
        DeliveryLoteNumber: DeliveryLoteNumber,
        ProductIsFatherComposition: ProductIsFatherComposition,
        ProductIdOfFather: ProductIdOfFather,
        children: children,
      );
}
