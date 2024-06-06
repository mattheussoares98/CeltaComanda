// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

class CartProductsViewModel extends Equatable {
  final ProductsViewModel Product;
  final String? Comments;
  final String TotalLiquid;
  final String Quantity;
  final String Value;
  final String ProductPriceLookUpCode;

  @override
  List get props => [
        Product,
        Comments,
        TotalLiquid,
        Quantity,
        Value,
        ProductPriceLookUpCode,
      ];

  const CartProductsViewModel({
    required this.Product,
    required this.Comments,
    required this.TotalLiquid,
    required this.Quantity,
    required this.Value,
    required this.ProductPriceLookUpCode,
  });

  factory CartProductsViewModel.fromEntity(CartProductEntity entity) =>
      CartProductsViewModel(
        Product: ProductsViewModel.fromEntity(entity.Product),
        Comments: entity.Comments,
        TotalLiquid: entity.TotalLiquid.toString(),
        Quantity: entity.Quantity.toString(),
        Value: entity.Value.toString(),
        ProductPriceLookUpCode: entity.ProductPriceLookUpCode,
      );

  CartProductEntity toEntity() => CartProductEntity(
        Product: Product.toEntity(),
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

  static CartProductsViewModel fromJson(Map json) => CartProductsViewModel(
        Product: ProductsViewModel.fromJson(json["Product"]),
        Comments: json["Comments"],
        TotalLiquid: json["TotalLiquid"],
        Quantity: json["Quantity"],
        Value: json["Value"],
        ProductPriceLookUpCode: json["ProductPriceLookUpCode"],
      );
}
