// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class TelephoneModel extends Equatable {
  final String AreaCode;
  final String PhoneNumber;

  const TelephoneModel({
    required this.AreaCode,
    required this.PhoneNumber,
  });

  @override
  List<Object?> get props => [AreaCode, PhoneNumber];

  factory TelephoneModel.fromJson(Map json) => TelephoneModel(
        AreaCode: json["AreaCode"],
        PhoneNumber: json["PhoneNumber"],
      );

  factory TelephoneModel.fromEntity(TelephoneEntity entity) => TelephoneModel(
        AreaCode: entity.AreaCode,
        PhoneNumber: entity.PhoneNumber,
      );

  Map<String, dynamic> toJson() => {
        "AreaCode": AreaCode,
        "PhoneNumber": PhoneNumber,
      };

  TelephoneEntity toEntity() => TelephoneEntity(
        AreaCode: AreaCode,
        PhoneNumber: PhoneNumber,
      );
}
