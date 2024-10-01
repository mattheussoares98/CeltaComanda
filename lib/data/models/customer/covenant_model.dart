// ignore_for_file: non_constant_identifier_names

import '../../../domain/entities/entities.dart';

class CovenantModel {
  final int Code;
  final String PersonalizedCode;
  final String Name;

  const CovenantModel({
    required this.Code,
    required this.PersonalizedCode,
    required this.Name,
  });

  factory CovenantModel.fromJson(Map json) => CovenantModel(
        Code: json["Code"],
        PersonalizedCode: json["PersonalizedCode"],
        Name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "Code": Code,
        "PersonalizedCode": PersonalizedCode,
        "Name": Name,
      };

  CovenantEntity toEntity() => CovenantEntity(
        Code: Code,
        PersonalizedCode: PersonalizedCode,
        Name: Name,
      );
}
