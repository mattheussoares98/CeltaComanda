// ignore_for_file: non_constant_identifier_names

import '../../domain/entities/entities.dart';

class SaleRequestTempProductEntity {
  final ProductEntity Product;
  final int SaleRequestProductTempId;
  final bool IsPrinted;
  final int SaleRequestTempId;
  final int ProductInternalCodeOnErp;
  final double TotalLiquid;
  final double Quantity;
  final double Value;
  final String ProductPriceLookUpCode;
  final String? Comments;
  final int? SaleRequestProductIdOfFather;
  final bool? ProductIsFatherComposition;

  SaleRequestTempProductEntity({
    required this.Product,
    required this.SaleRequestProductTempId,
    required this.IsPrinted,
    required this.SaleRequestTempId,
    required this.ProductInternalCodeOnErp,
    required this.TotalLiquid,
    required this.Quantity,
    required this.Value,
    required this.ProductPriceLookUpCode,
    required this.SaleRequestProductIdOfFather,
    required this.ProductIsFatherComposition,
    required this.Comments,
  });
}
