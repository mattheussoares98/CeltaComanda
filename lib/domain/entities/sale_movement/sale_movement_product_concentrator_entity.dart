import 'package:equatable/equatable.dart';

import '../entities.dart';

class SaleMovementProductConcentratorEntity extends Equatable {
  final int? SaleMovementProductId;
  final int? Position;
  final int? SaleRequestProductInternalCodeOnERP;
  final double? UnitValue;
  final double? Quantity;
  final bool? IsCancelled;
  final bool? IsToDelivery;
  final bool? IsPrinted;
  final String? Comments;
  final int? MotiveJustificationId;
  final String? MotiveJustificationName;
  final int? MotiveJustificationSaleDiscountId;
  final String? MotiveJustificationSaleDiscountName;
  final int? UserIdOfCancellation;
  final int? DiscountType;
  final double? DiscountValue;
  final int? UserIdOfDiscount;
  final int? SaleNegotiationDiscountType;
  final double? SaleNegotiationDiscountValue;
  final int? CRMDiscountType;
  final double? CRMDiscountValue;
  final int? IncrementType;
  final double? IncrementValue;
  final int? DeliveryTaxType;
  final double? DeliveryTaxValue;
  final String? ProductPluCode;
  final String? ProductEan;
  final String? ProductInternalCodeOnERP;
  final String? ProductName;
  final bool? ProductIsFatherComposition;
  final String? SaleMovementProductCompositionId;
  final String? IcmsTributarySituationCode;
  final double? IcmsAliquot;
  final double? IcmsStave;
  final double? IcmsReductionMargin;
  final double? IcmsIVAMargin;
  final int? PisType;
  final int? CofinsType;
  final int? BlockadeDiscountType;
  final double? PisPercentage;
  final double? CofinsPercentage;
  final double? SaleRetailPrice;
  final double? OfferRetailPrice;
  final double? WholeSalePrice;
  final double? WholeOfferPrice;
  final double? SaleECommercePrice;
  final double? OfferECommercePrice;
  final double? RepositionCost;
  final double? RepositionCostMiddle;
  final double? LiquidCost;
  final double? LiquidCostMiddle;
  final double? RepositionCostReal;
  final double? LiquidCostReal;
  final String? CFOP;
  final String? CSTPisCofins;
  final String? NatureOperationCodePisCofins;
  final String? SocialContributionCodePisCofins;
  final String? IcmsFiscalAdjustCode;
  final int? IcmsFiscalAdjustObservationCode;
  final double? IcmsFiscalOriginalAliquot;
  final String? IcmsFiscalBenefitCode;
  final int? SaleOfferCode;
  final double? SaleOfferQuantity;
  final int? SaleOfferDiscountType;
  final double? SaleOfferDiscountValue;
  final SaleMovementConcentratorEntity? SaleMovement;

  const SaleMovementProductConcentratorEntity({
    required this.SaleMovementProductId,
    required this.Position,
    required this.SaleRequestProductInternalCodeOnERP,
    required this.UnitValue,
    required this.Quantity,
    required this.IsCancelled,
    required this.IsToDelivery,
    required this.IsPrinted,
    required this.Comments,
    required this.MotiveJustificationId,
    required this.MotiveJustificationName,
    required this.MotiveJustificationSaleDiscountId,
    required this.MotiveJustificationSaleDiscountName,
    required this.UserIdOfCancellation,
    required this.DiscountType,
    required this.DiscountValue,
    required this.UserIdOfDiscount,
    required this.SaleNegotiationDiscountType,
    required this.SaleNegotiationDiscountValue,
    required this.CRMDiscountType,
    required this.CRMDiscountValue,
    required this.IncrementType,
    required this.IncrementValue,
    required this.DeliveryTaxType,
    required this.DeliveryTaxValue,
    required this.ProductPluCode,
    required this.ProductEan,
    required this.ProductInternalCodeOnERP,
    required this.ProductName,
    required this.ProductIsFatherComposition,
    required this.SaleMovementProductCompositionId,
    required this.IcmsTributarySituationCode,
    required this.IcmsAliquot,
    required this.IcmsStave,
    required this.IcmsReductionMargin,
    required this.IcmsIVAMargin,
    required this.PisType,
    required this.CofinsType,
    required this.BlockadeDiscountType,
    required this.PisPercentage,
    required this.CofinsPercentage,
    required this.SaleRetailPrice,
    required this.OfferRetailPrice,
    required this.WholeSalePrice,
    required this.WholeOfferPrice,
    required this.SaleECommercePrice,
    required this.OfferECommercePrice,
    required this.RepositionCost,
    required this.RepositionCostMiddle,
    required this.LiquidCost,
    required this.LiquidCostMiddle,
    required this.RepositionCostReal,
    required this.LiquidCostReal,
    required this.CFOP,
    required this.CSTPisCofins,
    required this.NatureOperationCodePisCofins,
    required this.SocialContributionCodePisCofins,
    required this.IcmsFiscalAdjustCode,
    required this.IcmsFiscalAdjustObservationCode,
    required this.IcmsFiscalOriginalAliquot,
    required this.IcmsFiscalBenefitCode,
    required this.SaleOfferCode,
    required this.SaleOfferQuantity,
    required this.SaleOfferDiscountType,
    required this.SaleOfferDiscountValue,
    required this.SaleMovement,
  });

  @override
  List<Object?> get props => [
        SaleMovementProductId,
        Position,
        SaleRequestProductInternalCodeOnERP,
        UnitValue,
        Quantity,
        IsCancelled,
        IsToDelivery,
        IsPrinted,
        Comments,
        MotiveJustificationId,
        MotiveJustificationName,
        MotiveJustificationSaleDiscountId,
        MotiveJustificationSaleDiscountName,
        UserIdOfCancellation,
        DiscountType,
        DiscountValue,
        UserIdOfDiscount,
        SaleNegotiationDiscountType,
        SaleNegotiationDiscountValue,
        CRMDiscountType,
        CRMDiscountValue,
        IncrementType,
        IncrementValue,
        DeliveryTaxType,
        DeliveryTaxValue,
        ProductPluCode,
        ProductEan,
        ProductInternalCodeOnERP,
        ProductName,
        ProductIsFatherComposition,
        SaleMovementProductCompositionId,
        IcmsTributarySituationCode,
        IcmsAliquot,
        IcmsStave,
        IcmsReductionMargin,
        IcmsIVAMargin,
        PisType,
        CofinsType,
        BlockadeDiscountType,
        PisPercentage,
        CofinsPercentage,
        SaleRetailPrice,
        OfferRetailPrice,
        WholeSalePrice,
        WholeOfferPrice,
        SaleECommercePrice,
        OfferECommercePrice,
        RepositionCost,
        RepositionCostMiddle,
        LiquidCost,
        LiquidCostMiddle,
        RepositionCostReal,
        LiquidCostReal,
        CFOP,
        CSTPisCofins,
        NatureOperationCodePisCofins,
        SocialContributionCodePisCofins,
        IcmsFiscalAdjustCode,
        IcmsFiscalAdjustObservationCode,
        IcmsFiscalOriginalAliquot,
        IcmsFiscalBenefitCode,
        SaleOfferCode,
        SaleOfferQuantity,
        SaleOfferDiscountType,
        SaleOfferDiscountValue,
        SaleMovement,
      ];
}
