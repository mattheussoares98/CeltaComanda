import 'entities.dart';

class SaleRequestProductEntity {
  final ProductEntity? Product;
  final int? SaleMovementProductCompositionId;
  final String? ProductPriceLookUpCode;
  final String? QuantityString;
  final String? Comments;
  final String? DateHourOfCreation;
  final bool? IsCancelled;
  final bool? IsDelivered;
  final bool? IsPrinted;
  final bool? ProductIsFatherComposition;
  final int? SaleRequestProductId;
  final int? UserId;
  final int? ProductionStatus;
  final int? ProductInternalCodeOnErp;
  final int? SaleRequestId;
  final int? UserIdOfCancellation;
  final double? Value;
  final double? Quantity;
  final double? TotalLiquid;
  final IsToDelivery? isToDelivery;
  final int? DeliveryLoteNumber;

  const SaleRequestProductEntity({
    required this.Product,
    required this.SaleMovementProductCompositionId,
    required this.ProductPriceLookUpCode,
    required this.QuantityString,
    required this.Comments,
    required this.DateHourOfCreation,
    required this.IsCancelled,
    required this.IsDelivered,
    required this.IsPrinted,
    required this.ProductIsFatherComposition,
    required this.SaleRequestProductId,
    required this.UserId,
    required this.ProductionStatus,
    required this.ProductInternalCodeOnErp,
    required this.SaleRequestId,
    required this.UserIdOfCancellation,
    required this.Value,
    required this.Quantity,
    required this.TotalLiquid,
    required this.isToDelivery,
    required this.DeliveryLoteNumber,
  });
}
