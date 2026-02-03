import 'package:equatable/equatable.dart';

class ConcSaleRequestProductEntity extends Equatable {
  final int? SaleRequestProductId;
  final int? InternalCodeOnERP;
  final String? ProductPlu;
  final String? EanCode;
  final double? Quantity;
  final int? UserId;
  final double? Value;
  final bool? IsCancelled;
  final int? UserIdOfCancellation;
  final bool? IsDelivered;
  final bool? IsPrinted;
  final String? Comments;
  final double? TotalLiquid;
  final int? SaleRequestId;
  final bool? ProductIsFatherComposition;
  final String? SaleRequestProductIdOfFather;
  final int? SaleRequestProductInternalCodeOnERP;
  final String? ProductName;
  final SaleBlockadeDiscountType? BlockadeDiscountType;
  final double? DiscountFromSaleOffer;
  final String? UserOfDiscount;
  final double? AveragedDiscount;
  final double? AveragedIncrement;
  final double? AveragedDeliveryTax;
  final double? SaleRetailPrice;
  final double? SaleRetailOffer;
  final double? WholeSalePrice;
  final double? WholeSaleOffer;
  final ConcSaleRequestProductEntity? SaleRequestProducOfFatherComposition;
  final DateTime? DateHourOfCreation;
// final ModelSaleRequest SaleRequest ;

  const ConcSaleRequestProductEntity({
    required this.SaleRequestProductId,
    required this.InternalCodeOnERP,
    required this.ProductPlu,
    required this.EanCode,
    required this.Quantity,
    required this.UserId,
    required this.Value,
    required this.IsCancelled,
    required this.UserIdOfCancellation,
    required this.IsDelivered,
    required this.IsPrinted,
    required this.Comments,
    required this.TotalLiquid,
    required this.SaleRequestId,
    required this.ProductIsFatherComposition,
    required this.SaleRequestProductIdOfFather,
    required this.SaleRequestProductInternalCodeOnERP,
    required this.ProductName,
    required this.BlockadeDiscountType,
    required this.DiscountFromSaleOffer,
    required this.UserOfDiscount,
    required this.AveragedDiscount,
    required this.AveragedIncrement,
    required this.AveragedDeliveryTax,
    required this.SaleRetailPrice,
    required this.SaleRetailOffer,
    required this.WholeSalePrice,
    required this.WholeSaleOffer,
    required this.SaleRequestProducOfFatherComposition,
    required this.DateHourOfCreation,
  });

  @override
  List<Object?> get props => [
        SaleRequestProductId,
        InternalCodeOnERP,
        ProductPlu,
        EanCode,
        Quantity,
        UserId,
        Value,
        IsCancelled,
        UserIdOfCancellation,
        IsDelivered,
        IsPrinted,
        Comments,
        TotalLiquid,
        SaleRequestId,
        ProductIsFatherComposition,
        SaleRequestProductIdOfFather,
        SaleRequestProductInternalCodeOnERP,
        ProductName,
        BlockadeDiscountType,
        DiscountFromSaleOffer,
        UserOfDiscount,
        AveragedDiscount,
        AveragedIncrement,
        AveragedDeliveryTax,
        SaleRetailPrice,
        SaleRetailOffer,
        WholeSalePrice,
        WholeSaleOffer,
        DateHourOfCreation,
      ];
}

enum SaleBlockadeDiscountType {
  none(1),
  blockadeByOfferPrice(2),
  blockadeByAutomaticDiscount(3),
  blockadeBySaleNegotiation(4),
  blockadeByWholeSalePrice(5);

  final int code;
  const SaleBlockadeDiscountType(this.code);
}
