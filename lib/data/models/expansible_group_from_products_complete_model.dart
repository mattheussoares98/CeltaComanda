import '../../domain/entities/entities.dart';

class ExpansibleGroupFromProductsCompleteModel {
  final String ProductName;
  final String GroupName;
  final int ExpansibleGroupId;
  final int ProductInternalCodeOnErp;

  ExpansibleGroupFromProductsCompleteModel({
    required this.ProductName,
    required this.GroupName,
    required this.ExpansibleGroupId,
    required this.ProductInternalCodeOnErp,
  });

  factory ExpansibleGroupFromProductsCompleteModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(
      [
        "ProductName",
        "ExpansibleGroupId",
        "ProductInternalCodeOnErp",
        "GroupName"
      ],
    )) {
      throw Exception();
    }

    return ExpansibleGroupFromProductsCompleteModel(
      ProductName: json["ProductName"],
      ExpansibleGroupId: json["ExpansibleGroupId"],
      ProductInternalCodeOnErp: json["ProductInternalCodeOnErp"],
      GroupName: json["GroupName"],
    );
  }

  factory ExpansibleGroupFromProductsCompleteModel.fromEntity(
          ExpansibleGroupFromProductsCompleteEntity entity) =>
      ExpansibleGroupFromProductsCompleteModel(
        ExpansibleGroupId: entity.ExpansibleGroupId,
        ProductInternalCodeOnErp: entity.ProductInternalCodeOnErp,
        ProductName: entity.ProductName,
        GroupName: entity.GroupName,
      );

  ExpansibleGroupFromProductsCompleteEntity toEntity() =>
      ExpansibleGroupFromProductsCompleteEntity(
        ProductName: ProductName,
        ExpansibleGroupId: ExpansibleGroupId,
        ProductInternalCodeOnErp: ProductInternalCodeOnErp,
        GroupName: GroupName,
      );

  Map<String, dynamic> toJson() => {
        "ProductName": ProductName,
        "ExpansibleGroupId": ExpansibleGroupId,
        "ProductInternalCodeOnErp": ProductInternalCodeOnErp,
        "GroupName": GroupName,
      };
}
