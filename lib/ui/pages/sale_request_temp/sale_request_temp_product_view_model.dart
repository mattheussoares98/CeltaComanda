// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';
import '../../../ui/helpers/helpers.dart';
import '../../../ui/pages/pages.dart';

class SaleRequestTempProductsViewModel extends Equatable {
  final ProductsViewModel Product;
  final String SaleRequestProductTempId;
  final String IsPrinted;
  final String? Comments;
  final String SaleRequestTempId;
  final String ProductInternalCodeOnErp;
  final String TotalLiquid;
  final String Quantity;
  final String Value;
  final String ProductPriceLookUpCode;

  @override
  List get props => [
        Product,
        SaleRequestProductTempId,
        IsPrinted,
        Comments,
        SaleRequestTempId,
        ProductInternalCodeOnErp,
        TotalLiquid,
        Quantity,
        Value,
        ProductPriceLookUpCode,
      ];

  const SaleRequestTempProductsViewModel({
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

  factory SaleRequestTempProductsViewModel.fromEntity(
          SaleRequestTempProductEntity entity) =>
      SaleRequestTempProductsViewModel(
        Product: ProductsViewModel.fromEntity(entity.Product),
        SaleRequestProductTempId: entity.SaleRequestProductTempId.toString(),
        IsPrinted: entity.IsPrinted.toString(),
        SaleRequestTempId: entity.SaleRequestTempId.toString(),
        ProductInternalCodeOnErp: entity.ProductInternalCodeOnErp.toString(),
        TotalLiquid: entity.TotalLiquid.toStringAsFixed(2).toBrazilianNumber(),
        Quantity: entity.Quantity.toStringAsFixed(2).toBrazilianNumber(),
        Value: entity.Value.toStringAsFixed(2).toBrazilianNumber(),
        Comments: entity.Comments,
        ProductPriceLookUpCode: entity.ProductPriceLookUpCode,
      );

  SaleRequestTempProductEntity toEntity() => SaleRequestTempProductEntity(
        Product: Product.toEntity(),
        SaleRequestProductTempId: int.parse(SaleRequestProductTempId),
        SaleRequestTempId: int.parse(SaleRequestTempId),
        ProductInternalCodeOnErp: int.parse(ProductInternalCodeOnErp),
        IsPrinted: bool.parse(IsPrinted),
        TotalLiquid: TotalLiquid.toDouble(),
        Quantity: Quantity.toDouble(),
        Value: Value.toDouble(),
        ProductPriceLookUpCode: ProductPriceLookUpCode,
        Comments: Comments,
      );
}
