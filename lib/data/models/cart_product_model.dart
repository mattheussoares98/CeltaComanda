// ignore_for_file: non_constant_identifier_names

import '../../domain/entities/entities.dart';

class CartProductModel {
  final ProductEntity Product;
  final String? Comments;
  final double TotalLiquid;
  final double Quantity;
  final double Value;
  final String ProductPriceLookUpCode;

  CartProductModel({
    required this.Product,
    required this.Comments,
    required this.TotalLiquid,
    required this.Quantity,
    required this.Value,
    required this.ProductPriceLookUpCode,
  });

  factory CartProductModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll([
      'Product',
      'Comments',
      'TotalLiquid',
      'Quantity',
      'Value',
      'ProductPriceLookUpCode',
    ])) {
      throw Exception();
    }
    return CartProductModel(
      Product: json['Product'],
      Comments: json['Comments'],
      TotalLiquid: json['TotalLiquid'],
      Quantity: json['Quantity'],
      Value: json['Value'],
      ProductPriceLookUpCode: json['ProductPriceLookUpCode'],
    );
  }

  factory CartProductModel.fromEntity(CartProductEntity entity) =>
      CartProductModel(
        Product: entity.Product,
        Comments: entity.Comments,
        TotalLiquid: entity.TotalLiquid,
        Quantity: entity.Quantity,
        Value: entity.Value,
        ProductPriceLookUpCode: entity.ProductPriceLookUpCode,
      );

  CartProductEntity toEntity() => CartProductEntity(
        Product: Product,
        Comments: Comments,
        TotalLiquid: TotalLiquid.toDouble(),
        Quantity: Quantity.toDouble(),
        Value: Value.toDouble(),
        ProductPriceLookUpCode: ProductPriceLookUpCode,
      );

  Map<String, dynamic> toJson() => {
        "Product": Product,
        "Comments": Comments,
        "TotalLiquid": TotalLiquid,
        "Quantity": Quantity,
        "Value": Value,
        "ProductPriceLookUpCode": ProductPriceLookUpCode,
      };
}
