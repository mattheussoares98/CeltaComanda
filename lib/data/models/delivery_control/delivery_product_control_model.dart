// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class DeliveryProductControlModel extends Equatable {
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

  const DeliveryProductControlModel({
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
          ? DateTime.fromMillisecondsSinceEpoch(map['DateHourOfCreation'] as int)
          : DateTime.parse(map['DateHourOfCreation'].toString()),
      isToDelivery: map['IsToDelivery'] is int
          ? IsToDelivery.values.firstWhere(
              (e) => e.value == map['IsToDelivery'],
              orElse: () => IsToDelivery.values[map['IsToDelivery'] as int],
            )
          : IsToDelivery.preparing,
      DateHourOfDelivery: map['DateHourOfDelivery'] != null
          ? (map['DateHourOfDelivery'] is int
              ? DateTime.fromMillisecondsSinceEpoch(map['DateHourOfDelivery'] as int)
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
      );
}
