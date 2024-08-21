// ignore_for_file: non_constant_identifier_names

import '../../domain/entities/entities.dart';

class SellerModel {
  final int SellersId;
  final int EnterpriseId;
  final String Name;
  final String PersonalizedCode;
  SellerModel({
    required this.SellersId,
    required this.EnterpriseId,
    required this.Name,
    required this.PersonalizedCode,
  });

  factory SellerModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll([
      'SellersId',
      'Name',
    ])) {
      throw Exception();
    }
    return SellerModel(
      SellersId: json['SellersId'],
      Name: json['Name'],
      EnterpriseId: json['EnterpriseId'],
      PersonalizedCode: json['PersonalizedCode'],
    );
  }

  factory SellerModel.fromEntity(SellerEntity entity) => SellerModel(
        SellersId: entity.SellersId,
        EnterpriseId: entity.EnterpriseId,
        Name: entity.Name,
        PersonalizedCode: entity.PersonalizedCode,
      );

  SellerEntity toEntity() => SellerEntity(
        SellersId: SellersId,
        EnterpriseId: EnterpriseId,
        Name: Name,
        PersonalizedCode: PersonalizedCode,
      );

  Map<String, dynamic> toJson() => {
        "SellersId": SellersId,
        "EnterpriseId": EnterpriseId,
        "Name": Name,
        "PersonalizedCode": PersonalizedCode,
      };
}
