// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class CovenantModel extends Equatable {
  final int Code;
  final String PersonalizedCode;
  final String Name;

  const CovenantModel({
    required this.Code,
    required this.PersonalizedCode,
    required this.Name,
  });

  @override
  List<Object?> get props => [Code, PersonalizedCode, Name];

  factory CovenantModel.fromJson(Map json) => CovenantModel(
        Code: json["Covenant"]["Code"],
        PersonalizedCode: json["Covenant"]["PersonalizedCode"],
        Name: json["Covenant"]["Name"],
      );

  factory CovenantModel.fromEntity(CovenantEntity entity) => CovenantModel(
        Code: entity.Code,
        PersonalizedCode: entity.PersonalizedCode,
        Name: entity.Name,
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
