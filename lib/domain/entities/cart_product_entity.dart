// ignore_for_file: non_constant_identifier_names
import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class CartProductEntity extends Equatable {
  final ProductEntity Product;
  final String? Comments;
  final double TotalLiquid;
  final double Quantity;
  final double Value;
  final String ProductPriceLookUpCode;

  const CartProductEntity({
    required this.Product,
    required this.Comments,
    required this.TotalLiquid,
    required this.Quantity,
    required this.Value,
    required this.ProductPriceLookUpCode,
  });

  @override
  List get props => [
        Product,
        Comments,
        TotalLiquid,
        Quantity,
        Value,
        ProductPriceLookUpCode,
      ];
}
