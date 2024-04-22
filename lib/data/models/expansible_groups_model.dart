// ignore_for_file: non_constant_identifier_names

import '../../domain/entities/entities.dart';

class ExpansibleGroupsModel {
  final String Name;
  final int ExpansibleGroupId;
  final int ExpansibleGroupType;
  final int OrderClassification;

  ExpansibleGroupsModel({
    required this.Name,
    required this.ExpansibleGroupId,
    required this.ExpansibleGroupType,
    required this.OrderClassification,
  });

  factory ExpansibleGroupsModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(
      [
        "Name",
        "ExpansibleGroupId",
        "ExpansibleGroupType",
        "OrderClassification"
      ],
    )) {
      throw Exception();
    }

    return ExpansibleGroupsModel(
      Name: json["Name"],
      ExpansibleGroupId: json["ExpansibleGroupId"],
      ExpansibleGroupType: json["ExpansibleGroupType"],
      OrderClassification: json["OrderClassification"],
    );
  }

  factory ExpansibleGroupsModel.fromEntity(ExpansibleGroupEntity entity) =>
      ExpansibleGroupsModel(
        ExpansibleGroupId: entity.ExpansibleGroupId,
        ExpansibleGroupType: entity.ExpansibleGroupType,
        Name: entity.Name,
        OrderClassification: entity.OrderClassification,
      );

  ExpansibleGroupEntity toEntity() => ExpansibleGroupEntity(
        Name: Name,
        ExpansibleGroupId: ExpansibleGroupId,
        ExpansibleGroupType: ExpansibleGroupType,
        OrderClassification: OrderClassification,
      );

  Map<String, dynamic> toJson() => {
        "Name": Name,
        "ExpansibleGroupId": ExpansibleGroupId,
        "ExpansibleGroupType": ExpansibleGroupType,
        "OrderClassification": OrderClassification,
      };
}
