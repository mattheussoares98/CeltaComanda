import 'package:equatable/equatable.dart';

import 'product_entity.dart';

class PrintedProductsEntity extends Equatable {
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
  final bool ProductIsFatherComposition;
  final int? SaleRequestProductIdOfFather;
  final int? SaleMovementProductCompositionId;
  final int? UserIdOfCancellation;
  final List<PrintedProductsEntity> childs;

  const PrintedProductsEntity({
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
    required this.ProductIsFatherComposition,
    required this.childs,
    required this.SaleRequestProductIdOfFather,
    required this.SaleMovementProductCompositionId,
    required this.UserIdOfCancellation,
  });

  @override
  List<Object?> get props => [
        Product,
        SaleRequestProductId,
        ProductPriceLookUpCode,
        Value,
        Quantity,
        QuantityString,
        Comments,
        UserId,
        DateHourOfCreation,
        IsCancelled,
        IsDelivered,
        IsPrinted,
        ProductionStatus,
        TotalLiquid,
        ProductInternalCodeOnErp,
        SaleRequestId,
        ProductIsFatherComposition,
        childs,
        SaleRequestProductIdOfFather,
        SaleMovementProductCompositionId,
        UserIdOfCancellation,
      ];
}
