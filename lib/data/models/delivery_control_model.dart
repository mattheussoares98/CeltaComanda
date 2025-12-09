// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class DeliveryControlModel extends Equatable {
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

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'Id': Id,
      'EnterpriseId': EnterpriseId,
      'EnterpriseCode': EnterpriseCode,
      'OriginType': OriginType,
      'PersonalizedCode': PersonalizedCode,
      'CouponFiscalNumber': CouponFiscalNumber,
      'DateOfCreation': DateOfCreation.millisecondsSinceEpoch,
      'DateHourOfCreation': DateHourOfCreation.millisecondsSinceEpoch,
      'IsCancelled': IsCancelled,
      'IsToDelivery': IsToDelivery,
      'DateHourOfDelivery': DateHourOfDelivery?.millisecondsSinceEpoch,
      'DeliveryControl': DeliveryControl,
      'DeliveryStatusLate': DeliveryStatusLate,
    };
  }

  factory DeliveryControlModel.fromJson(Map<String, dynamic> map) {
    return DeliveryControlModel(
      Id: map['Id'] as int,
      EnterpriseId: map['EnterpriseId'] as int,
      EnterpriseCode: map['EnterpriseCode'] as int,
      OriginType: map['OriginType'] as int,
      PersonalizedCode: map['PersonalizedCode'] as String,
      CouponFiscalNumber: map['CouponFiscalNumber'] != null
          ? map['CouponFiscalNumber'] as int
          : null,
      DateOfCreation:
          DateTime.fromMillisecondsSinceEpoch(map['DateOfCreation'] as int),
      DateHourOfCreation:
          DateTime.fromMillisecondsSinceEpoch(map['DateHourOfCreation'] as int),
      IsCancelled: map['IsCancelled'] as bool,
      IsToDelivery: map['IsToDelivery'] as int,
      DateHourOfDelivery: map['DateHourOfDelivery'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['DateHourOfDelivery'] as int)
          : null,
      DeliveryControl:
          map['DeliveryControl'] != null ? map['DeliveryControl'] as int : null,
      DeliveryStatusLate: map['DeliveryStatusLate'] as int,
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
        IsToDelivery: entity.IsToDelivery,
        DateHourOfDelivery: entity.DateHourOfDelivery,
        DeliveryControl: entity.DeliveryControl,
        DeliveryStatusLate: entity.DeliveryStatusLate,
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
        IsToDelivery: IsToDelivery,
        DateHourOfDelivery: DateHourOfDelivery,
        DeliveryControl: DeliveryControl,
        DeliveryStatusLate: DeliveryStatusLate,
      );
}
