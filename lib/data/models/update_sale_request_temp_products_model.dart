

import '../../domain/entities/entities.dart';

class UpdateSaleRequestTempProductsModel {
  final int ProductInternalCodeOnErp;
  final String ProductPriceLookUpCode;
  final double Quantity;
  final int SaleRequestTempId;
  final double TotalLiquid;
  final double Value;
  final String? Comments;
  final int? SaleRequestProductIdOfFather;
  final bool? ProductIsFatherComposition;

  UpdateSaleRequestTempProductsModel({
    required this.ProductInternalCodeOnErp,
    required this.ProductPriceLookUpCode,
    required this.Quantity,
    required this.SaleRequestTempId,
    required this.TotalLiquid,
    required this.Value,
    required this.Comments,
    required this.SaleRequestProductIdOfFather,
    required this.ProductIsFatherComposition,
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
      Comments: json["Comments"],
      SaleRequestProductIdOfFather: json["SaleRequestProductIdOfFather"],
      ProductIsFatherComposition: json["ProductIsFatherComposition"],
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
        Comments: entity.Comments,
        SaleRequestProductIdOfFather: entity.SaleRequestProductIdOfFather,
        ProductIsFatherComposition: entity.ProductIsFatherComposition,
      );

  UpdateSaleRequestTempProductEntity toEntity() =>
      UpdateSaleRequestTempProductEntity(
        ProductInternalCodeOnErp: ProductInternalCodeOnErp,
        ProductPriceLookUpCode: ProductPriceLookUpCode,
        Quantity: Quantity,
        SaleRequestTempId: SaleRequestTempId,
        TotalLiquid: TotalLiquid,
        Value: Value,
        Comments: Comments,
        SaleRequestProductIdOfFather: SaleRequestProductIdOfFather,
        ProductIsFatherComposition: ProductIsFatherComposition,
      );

  Map<dynamic, dynamic> toJson() => {
        "ProductInternalCodeOnErp": ProductInternalCodeOnErp,
        "ProductPriceLookUpCode": ProductPriceLookUpCode,
        "Quantity": Quantity,
        "SaleRequestTempId": SaleRequestTempId,
        "TotalLiquid": TotalLiquid,
        "Value": Value,
        "Comments": Comments,
        "SaleRequestProductIdOfFather": SaleRequestProductIdOfFather,
        "ProductIsFatherComposition": ProductIsFatherComposition,
      };
}
