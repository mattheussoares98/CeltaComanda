// ignore_for_file: non_constant_identifier_names

import 'product_entity.dart';

class PrintedProductsEntity {
  final ProductEntity Product;
  final int SaleRequestProductId;
  final String ProductPriceLookUpCode;
  final double Value;
  final double Quantity;
  final String QuantityString;
  final String? Comments;
  final int UserId;
  final String DateHourOfCreation;
  final bool IsCancelled;
  final bool IsDelivered;
  final bool IsPrinted;
  final int ProductionStatus;
  final double TotalLiquid;
  final int ProductInternalCodeOnErp;
  final int SaleRequestId;

  PrintedProductsEntity({
    required this.Product,
    required this.SaleRequestProductId,
    required this.ProductPriceLookUpCode,
    required this.Value,
    required this.Quantity,
    required this.QuantityString,
    required this.Comments,
    required this.UserId,
    required this.DateHourOfCreation,
    required this.IsCancelled,
    required this.IsDelivered,
    required this.IsPrinted,
    required this.ProductionStatus,
    required this.TotalLiquid,
    required this.ProductInternalCodeOnErp,
    required this.SaleRequestId,
  });
}
