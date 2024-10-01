// ignore_for_file: non_constant_identifier_names

import '../../../domain/entities/entities.dart';

class TelephoneModel {
  final String AreaCode;
  final String PhoneNumber;

  const TelephoneModel({
    required this.AreaCode,
    required this.PhoneNumber,
  });

  factory TelephoneModel.fromJson(Map json) => TelephoneModel(
        AreaCode: json["AreaCode"],
        PhoneNumber: json["PhoneNumber"],
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
