// ignore_for_file: non_constant_identifier_names

import '../../domain/entities/entities.dart';

class UpdateSaleRequestTempProductsModel {
  final int ProductInternalCodeOnErp;
  final String ProductPriceLookUpCode;
  final int Quantity;
  final int SaleRequestTempId;
  final double TotalLiquid;
  final double Value;

  UpdateSaleRequestTempProductsModel({
    required this.ProductInternalCodeOnErp,
    required this.ProductPriceLookUpCode,
    required this.Quantity,
    required this.SaleRequestTempId,
    required this.TotalLiquid,
    required this.Value,
  });

  factory UpdateSaleRequestTempProductsModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(
      [
        "ProductInternalCodeOnErp",
        "ProductPriceLookUpCode",
        "Quantity",
        "SaleRequestTempId",
        "TotalLiquid",
        "Value",
      ],
    )) {
      throw Exception();
    }

    return UpdateSaleRequestTempProductsModel(
      ProductInternalCodeOnErp: json["ProductInternalCodeOnErp"],
      ProductPriceLookUpCode: json["ProductPriceLookUpCode"],
      Quantity: json["Quantity"],
      SaleRequestTempId: json["SaleRequestTempId"],
      TotalLiquid: json["TotalLiquid"],
      Value: json["Value"],
    );
  }

  factory UpdateSaleRequestTempProductsModel.fromEntity(
          UpdateSaleRequestTempProductEntity entity) =>
      UpdateSaleRequestTempProductsModel(
        ProductInternalCodeOnErp: entity.ProductInternalCodeOnErp,
        ProductPriceLookUpCode: entity.ProductPriceLookUpCode,
        Quantity: entity.Quantity,
        SaleRequestTempId: entity.SaleRequestTempId,
        TotalLiquid: entity.TotalLiquid,
        Value: entity.Value,
      );

  UpdateSaleRequestTempProductEntity toEntity() =>
      UpdateSaleRequestTempProductEntity(
        ProductInternalCodeOnErp: ProductInternalCodeOnErp,
        ProductPriceLookUpCode: ProductPriceLookUpCode,
        Quantity: Quantity,
        SaleRequestTempId: SaleRequestTempId,
        TotalLiquid: TotalLiquid,
        Value: Value,
      );

  Map<dynamic, dynamic> toJson() => {
        "ProductInternalCodeOnErp": ProductInternalCodeOnErp,
        "ProductPriceLookUpCode": ProductPriceLookUpCode,
        "Quantity": Quantity,
        "SaleRequestTempId": SaleRequestTempId,
        "TotalLiquid": TotalLiquid,
        "Value": Value,
      };
}
