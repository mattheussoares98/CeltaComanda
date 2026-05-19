// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class DeliveryControlModel extends Equatable {
  final int Id;
  final int EnterpriseId;
  final int EnterpriseCode;
  final DeliveryOriginType OriginType;
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

  const DeliveryControlModel({
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
      'DeliveryStatusLate': DeliveryStatusLate,
      'TotalLiquid': TotalLiquid,
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
      isToDelivery: IsToDelivery.values[map['IsToDelivery']],
      DateHourOfDelivery: map['DateHourOfDelivery'] != null
          ? DateTime.parse(map['DateHourOfDelivery'])
          : null,
      DeliveryControl:
          map['DeliveryControl'] != null ? map['DeliveryControl'] as int : null,
      DeliveryStatusLate: map['DeliveryStatusLate'] as int,
      TotalLiquid: map['TotalLiquid'] as double,
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
        DeliveryStatusLate: entity.DeliveryStatusLate,
        TotalLiquid: entity.TotalLiquid,
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
        DeliveryStatusLate: DeliveryStatusLate,
        TotalLiquid: TotalLiquid,
      );
}
