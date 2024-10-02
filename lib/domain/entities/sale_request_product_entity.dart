// ignore_for_file: non_constant_identifier_names

class SaleRequestProductEntity {
  final String SaleMovementProductCompositionId;
  final String ProductPriceLookUpCode;
  final String QuantityString;
  final String Comments;
  final String DateHourOfCreation;
  final bool IsCancelled;
  final bool IsDelivered;
  final bool IsPrinted;
  final int SaleRequestProductId;
  final int UserId;
  final int ProductionStatus;
  final int ProductInternalCodeOnErp;
  final int SaleRequestId;
  final double Value;
  final double Quantity;
  final double TotalLiquid;

  const SaleRequestProductEntity({
    required this.SaleMovementProductCompositionId,
    required this.ProductPriceLookUpCode,
    required this.QuantityString,
    required this.Comments,
    required this.DateHourOfCreation,
    required this.IsCancelled,
    required this.IsDelivered,
    required this.IsPrinted,
    required this.SaleRequestProductId,
    required this.UserId,
    required this.ProductionStatus,
    required this.ProductInternalCodeOnErp,
    required this.SaleRequestId,
    required this.Value,
    required this.Quantity,
    required this.TotalLiquid,
  });
}
