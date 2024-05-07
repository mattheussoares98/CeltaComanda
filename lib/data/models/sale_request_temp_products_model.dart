// ignore_for_file: non_constant_identifier_names

import '../../domain/entities/entities.dart';
import 'product_model.dart';

class SaleRequestTempProductsModel {
  final ProductModel Product;
  final int SaleRequestProductTempId;
  final bool IsPrinted;
  final String? Comments;
  final int SaleRequestTempId;
  final int ProductInternalCodeOnErp;
  final double TotalLiquid;
  final double Quantity;
  final double Value;
  final String ProductPriceLookUpCode;

  SaleRequestTempProductsModel({
    required this.Product,
    required this.SaleRequestProductTempId,
    required this.IsPrinted,
    required this.Comments,
    required this.SaleRequestTempId,
    required this.ProductInternalCodeOnErp,
    required this.TotalLiquid,
    required this.Quantity,
    required this.Value,
    required this.ProductPriceLookUpCode,
  });

  factory SaleRequestTempProductsModel.fromJson(Map<String, dynamic> json) {
    if (!json.keys.toSet().containsAll(
      [
        "Product",
        "SaleRequestProductTempId",
        "IsPrinted",
        "Comments",
        "SaleRequestTempId",
        "ProductInternalCodeOnErp",
        "TotalLiquid",
        "Quantity",
        "Value",
        "ProductPriceLookUpCode",
      ],
    )) {
      throw Exception();
    }

    return SaleRequestTempProductsModel(
      Product: ProductModel.fromJson(json["Product"]),
      SaleRequestProductTempId: json["SaleRequestProductTempId"],
      IsPrinted: json["IsPrinted"],
      Comments: json["Comments"],
      SaleRequestTempId: json["SaleRequestTempId"],
      ProductInternalCodeOnErp: json["ProductInternalCodeOnErp"],
      TotalLiquid: json["TotalLiquid"],
      Quantity: json["Quantity"],
      Value: json["Value"],
      ProductPriceLookUpCode: json["ProductPriceLookUpCode"],
    );
  }

  factory SaleRequestTempProductsModel.fromEntity(
      SaleRequestTempProductEntity entity) {
    return SaleRequestTempProductsModel(
      Product: ProductModel.fromEntity(entity.Product),
      SaleRequestProductTempId: entity.SaleRequestProductTempId,
      IsPrinted: entity.IsPrinted,
      Comments: entity.Comments,
      SaleRequestTempId: entity.SaleRequestTempId,
      ProductInternalCodeOnErp: entity.ProductInternalCodeOnErp,
      TotalLiquid: entity.TotalLiquid,
      Quantity: entity.Quantity,
      Value: entity.Value,
      ProductPriceLookUpCode: entity.ProductPriceLookUpCode,
    );
  }

  Map toJson() => {
        "Product": Product.toJson(),
        "SaleRequestProductTempId": SaleRequestProductTempId,
        "IsPrinted": IsPrinted,
        "Comments": Comments,
        "SaleRequestTempId": SaleRequestTempId,
        "ProductInternalCodeOnErp": ProductInternalCodeOnErp,
        "TotalLiquid": TotalLiquid,
        "Quantity": Quantity,
        "Value": Value,
        "ProductPriceLookUpCode": ProductPriceLookUpCode,
      };

  SaleRequestTempProductEntity toEntity() => SaleRequestTempProductEntity(
        Product: Product.toEntity(),
        SaleRequestProductTempId: SaleRequestProductTempId,
        IsPrinted: IsPrinted,
        SaleRequestTempId: SaleRequestTempId,
        ProductInternalCodeOnErp: ProductInternalCodeOnErp,
        TotalLiquid: TotalLiquid,
        Quantity: Quantity,
        Value: Value,
        ProductPriceLookUpCode: ProductPriceLookUpCode,
        Comments: Comments,
      );
}
