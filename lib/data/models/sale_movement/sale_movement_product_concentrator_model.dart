// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class SaleMovementProductConcentratorModel extends Equatable {
  final int? SaleMovementProductId;
  final int? Position;
  final int? SaleRequestProductInternalCodeOnERP;
  final int? MotiveJustificationId;
  final int? MotiveJustificationSaleDiscountId;
  final int? UserIdOfCancellation;
  final int? DiscountType;
  final int? UserIdOfDiscount;
  final int? SaleNegotiationDiscountType;
  final int? CRMDiscountType;
  final int? IncrementType;
  final int? DeliveryTaxType;
  final int? PisType;
  final int? CofinsType;
  final int? IcmsFiscalAdjustObservationCode;
  final int? SaleOfferCode;
  final int? SaleOfferDiscountType;
  final double? UnitValue;
  final double? Quantity;
  final double? DiscountValue;
  final double? SaleNegotiationDiscountValue;
  final double? CRMDiscountValue;
  final double? IncrementValue;
  final double? DeliveryTaxValue;
  final double? IcmsAliquot;
  final double? IcmsStave;
  final double? IcmsReductionMargin;
  final double? IcmsIVAMargin;
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
  final double? IcmsFiscalOriginalAliquot;
  final double? SaleOfferQuantity;
  final double? SaleOfferDiscountValue;
  final String? Comments;
  final String? MotiveJustificationName;
  final String? MotiveJustificationSaleDiscountName;
  final String? ProductPluCode;
  final String? ProductEan;
  final String? ProductInternalCodeOnERP;
  final String? ProductName;
  final String? SaleMovementProductCompositionId;
  final String? IcmsTributarySituationCode;
  final String? CFOP;
  final String? CSTPisCofins;
  final String? NatureOperationCodePisCofins;
  final String? SocialContributionCodePisCofins;
  final String? IcmsFiscalAdjustCode;
  final String? IcmsFiscalBenefitCode;
  final bool? IsCancelled;
  final bool? IsToDelivery;
  final bool? IsPrinted;
  final bool? ProductIsFatherComposition;

  const SaleMovementProductConcentratorModel({
    required this.SaleMovementProductId,
    required this.Position,
    required this.SaleRequestProductInternalCodeOnERP,
    required this.MotiveJustificationId,
    required this.MotiveJustificationSaleDiscountId,
    required this.UserIdOfCancellation,
    required this.DiscountType,
    required this.UserIdOfDiscount,
    required this.SaleNegotiationDiscountType,
    required this.CRMDiscountType,
    required this.IncrementType,
    required this.DeliveryTaxType,
    required this.PisType,
    required this.CofinsType,
    required this.IcmsFiscalAdjustObservationCode,
    required this.SaleOfferCode,
    required this.SaleOfferDiscountType,
    required this.UnitValue,
    required this.Quantity,
    required this.DiscountValue,
    required this.SaleNegotiationDiscountValue,
    required this.CRMDiscountValue,
    required this.IncrementValue,
    required this.DeliveryTaxValue,
    required this.IcmsAliquot,
    required this.IcmsStave,
    required this.IcmsReductionMargin,
    required this.IcmsIVAMargin,
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
    required this.IcmsFiscalOriginalAliquot,
    required this.SaleOfferQuantity,
    required this.SaleOfferDiscountValue,
    required this.Comments,
    required this.MotiveJustificationName,
    required this.MotiveJustificationSaleDiscountName,
    required this.ProductPluCode,
    required this.ProductEan,
    required this.ProductInternalCodeOnERP,
    required this.ProductName,
    required this.SaleMovementProductCompositionId,
    required this.IcmsTributarySituationCode,
    required this.CFOP,
    required this.CSTPisCofins,
    required this.NatureOperationCodePisCofins,
    required this.SocialContributionCodePisCofins,
    required this.IcmsFiscalAdjustCode,
    required this.IcmsFiscalBenefitCode,
    required this.IsCancelled,
    required this.IsToDelivery,
    required this.IsPrinted,
    required this.ProductIsFatherComposition,
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
      ];

  factory SaleMovementProductConcentratorModel.fromJson(Map data) =>
      SaleMovementProductConcentratorModel(
        SaleMovementProductId: data["SaleMovementProductId"],
        Position: data["Position"],
        SaleRequestProductInternalCodeOnERP:
            data["SaleRequestProductInternalCodeOnERP"],
        UnitValue: data["UnitValue"],
        Quantity: data["Quantity"],
        IsCancelled: data["IsCancelled"],
        IsToDelivery: data["IsToDelivery"],
        IsPrinted: data["IsPrinted"],
        Comments: data["Comments"],
        MotiveJustificationId: data["MotiveJustificationId"],
        MotiveJustificationName: data["MotiveJustificationName"],
        MotiveJustificationSaleDiscountId:
            data["MotiveJustificationSaleDiscountId"],
        MotiveJustificationSaleDiscountName:
            data["MotiveJustificationSaleDiscountName"],
        UserIdOfCancellation: data["UserIdOfCancellation"],
        DiscountType: data["DiscountType"],
        DiscountValue: data["DiscountValue"],
        UserIdOfDiscount: data["UserIdOfDiscount"],
        SaleNegotiationDiscountType: data["SaleNegotiationDiscountType"],
        SaleNegotiationDiscountValue: data["SaleNegotiationDiscountValue"],
        CRMDiscountType: data["CRMDiscountType"],
        CRMDiscountValue: data["CRMDiscountValue"],
        IncrementType: data["IncrementType"],
        IncrementValue: data["IncrementValue"],
        DeliveryTaxType: data["DeliveryTaxType"],
        DeliveryTaxValue: data["DeliveryTaxValue"],
        ProductPluCode: data["ProductPluCode"],
        ProductEan: data["ProductEan"],
        ProductInternalCodeOnERP: data["ProductInternalCodeOnERP"],
        ProductName: data["ProductName"],
        ProductIsFatherComposition: data["ProductIsFatherComposition"],
        SaleMovementProductCompositionId:
            data["SaleMovementProductCompositionId"],
        IcmsTributarySituationCode: data["IcmsTributarySituationCode"],
        IcmsAliquot: data["IcmsAliquot"],
        IcmsStave: data["IcmsStave"],
        IcmsReductionMargin: data["IcmsReductionMargin"],
        IcmsIVAMargin: data["IcmsIVAMargin"],
        PisType: data["PisType"],
        CofinsType: data["CofinsType"],
        PisPercentage: data["PisPercentage"],
        CofinsPercentage: data["CofinsPercentage"],
        SaleRetailPrice: data["SaleRetailPrice"],
        OfferRetailPrice: data["OfferRetailPrice"],
        WholeSalePrice: data["WholeSalePrice"],
        WholeOfferPrice: data["WholeOfferPrice"],
        SaleECommercePrice: data["SaleECommercePrice"],
        OfferECommercePrice: data["OfferECommercePrice"],
        RepositionCost: data["RepositionCost"],
        RepositionCostMiddle: data["RepositionCostMiddle"],
        LiquidCost: data["LiquidCost"],
        LiquidCostMiddle: data["LiquidCostMiddle"],
        RepositionCostReal: data["RepositionCostReal"],
        LiquidCostReal: data["LiquidCostReal"],
        CFOP: data["CFOP"],
        CSTPisCofins: data["CSTPisCofins"],
        NatureOperationCodePisCofins: data["NatureOperationCodePisCofins"],
        SocialContributionCodePisCofins:
            data["SocialContributionCodePisCofins"],
        IcmsFiscalAdjustCode: data["IcmsFiscalAdjustCode"],
        IcmsFiscalAdjustObservationCode:
            data["IcmsFiscalAdjustObservationCode"],
        IcmsFiscalOriginalAliquot: data["IcmsFiscalOriginalAliquot"],
        IcmsFiscalBenefitCode: data["IcmsFiscalBenefitCode"],
        SaleOfferCode: data["SaleOfferCode"],
        SaleOfferQuantity: data["SaleOfferQuantity"],
        SaleOfferDiscountType: data["SaleOfferDiscountType"],
        SaleOfferDiscountValue: data["SaleOfferDiscountValue"],
      );

  Map<String, dynamic> toJson() => {
        "SaleMovementProductId": SaleMovementProductId,
        "Position": Position,
        "SaleRequestProductInternalCodeOnERP":
            SaleRequestProductInternalCodeOnERP,
        "UnitValue": UnitValue,
        "Quantity": Quantity,
        "IsCancelled": IsCancelled,
        "IsToDelivery": IsToDelivery,
        "IsPrinted": IsPrinted,
        "Comments": Comments,
        "MotiveJustificationId": MotiveJustificationId,
        "MotiveJustificationName": MotiveJustificationName,
        "MotiveJustificationSaleDiscountId": MotiveJustificationSaleDiscountId,
        "MotiveJustificationSaleDiscountName":
            MotiveJustificationSaleDiscountName,
        "UserIdOfCancellation": UserIdOfCancellation,
        "DiscountType": DiscountType,
        "DiscountValue": DiscountValue,
        "UserIdOfDiscount": UserIdOfDiscount,
        "SaleNegotiationDiscountType": SaleNegotiationDiscountType,
        "SaleNegotiationDiscountValue": SaleNegotiationDiscountValue,
        "CRMDiscountType": CRMDiscountType,
        "CRMDiscountValue": CRMDiscountValue,
        "IncrementType": IncrementType,
        "IncrementValue": IncrementValue,
        "DeliveryTaxType": DeliveryTaxType,
        "DeliveryTaxValue": DeliveryTaxValue,
        "ProductPluCode": ProductPluCode,
        "ProductEan": ProductEan,
        "ProductInternalCodeOnERP": ProductInternalCodeOnERP,
        "ProductName": ProductName,
        "ProductIsFatherComposition": ProductIsFatherComposition,
        "SaleMovementProductCompositionId": SaleMovementProductCompositionId,
        "IcmsTributarySituationCode": IcmsTributarySituationCode,
        "IcmsAliquot": IcmsAliquot,
        "IcmsStave": IcmsStave,
        "IcmsReductionMargin": IcmsReductionMargin,
        "IcmsIVAMargin": IcmsIVAMargin,
        "PisType": PisType,
        "CofinsType": CofinsType,
        "PisPercentage": PisPercentage,
        "CofinsPercentage": CofinsPercentage,
        "SaleRetailPrice": SaleRetailPrice,
        "OfferRetailPrice": OfferRetailPrice,
        "WholeSalePrice": WholeSalePrice,
        "WholeOfferPrice": WholeOfferPrice,
        "SaleECommercePrice": SaleECommercePrice,
        "OfferECommercePrice": OfferECommercePrice,
        "RepositionCost": RepositionCost,
        "RepositionCostMiddle": RepositionCostMiddle,
        "LiquidCost": LiquidCost,
        "LiquidCostMiddle": LiquidCostMiddle,
        "RepositionCostReal": RepositionCostReal,
        "LiquidCostReal": LiquidCostReal,
        "CFOP": CFOP,
        "CSTPisCofins": CSTPisCofins,
        "NatureOperationCodePisCofins": NatureOperationCodePisCofins,
        "SocialContributionCodePisCofins": SocialContributionCodePisCofins,
        "IcmsFiscalAdjustCode": IcmsFiscalAdjustCode,
        "IcmsFiscalAdjustObservationCode": IcmsFiscalAdjustObservationCode,
        "IcmsFiscalOriginalAliquot": IcmsFiscalOriginalAliquot,
        "IcmsFiscalBenefitCode": IcmsFiscalBenefitCode,
        "SaleOfferCode": SaleOfferCode,
        "SaleOfferQuantity": SaleOfferQuantity,
        "SaleOfferDiscountType": SaleOfferDiscountType,
        "SaleOfferDiscountValue": SaleOfferDiscountValue,
      };

  SaleMovementProductConcentratorEntity toEntity() =>
      SaleMovementProductConcentratorEntity(
        SaleMovementProductId: SaleMovementProductId,
        Position: Position,
        SaleRequestProductInternalCodeOnERP:
            SaleRequestProductInternalCodeOnERP,
        UnitValue: UnitValue,
        Quantity: Quantity,
        IsCancelled: IsCancelled,
        IsToDelivery: IsToDelivery,
        IsPrinted: IsPrinted,
        Comments: Comments,
        MotiveJustificationId: MotiveJustificationId,
        MotiveJustificationName: MotiveJustificationName,
        MotiveJustificationSaleDiscountId: MotiveJustificationSaleDiscountId,
        MotiveJustificationSaleDiscountName:
            MotiveJustificationSaleDiscountName,
        UserIdOfCancellation: UserIdOfCancellation,
        DiscountType: DiscountType,
        DiscountValue: DiscountValue,
        UserIdOfDiscount: UserIdOfDiscount,
        SaleNegotiationDiscountType: SaleNegotiationDiscountType,
        SaleNegotiationDiscountValue: SaleNegotiationDiscountValue,
        CRMDiscountType: CRMDiscountType,
        CRMDiscountValue: CRMDiscountValue,
        IncrementType: IncrementType,
        IncrementValue: IncrementValue,
        DeliveryTaxType: DeliveryTaxType,
        DeliveryTaxValue: DeliveryTaxValue,
        ProductPluCode: ProductPluCode,
        ProductEan: ProductEan,
        ProductInternalCodeOnERP: ProductInternalCodeOnERP,
        ProductName: ProductName,
        ProductIsFatherComposition: ProductIsFatherComposition,
        SaleMovementProductCompositionId: SaleMovementProductCompositionId,
        IcmsTributarySituationCode: IcmsTributarySituationCode,
        IcmsAliquot: IcmsAliquot,
        IcmsStave: IcmsStave,
        IcmsReductionMargin: IcmsReductionMargin,
        IcmsIVAMargin: IcmsIVAMargin,
        PisType: PisType,
        CofinsType: CofinsType,
        PisPercentage: PisPercentage,
        CofinsPercentage: CofinsPercentage,
        SaleRetailPrice: SaleRetailPrice,
        OfferRetailPrice: OfferRetailPrice,
        WholeSalePrice: WholeSalePrice,
        WholeOfferPrice: WholeOfferPrice,
        SaleECommercePrice: SaleECommercePrice,
        OfferECommercePrice: OfferECommercePrice,
        RepositionCost: RepositionCost,
        RepositionCostMiddle: RepositionCostMiddle,
        LiquidCost: LiquidCost,
        LiquidCostMiddle: LiquidCostMiddle,
        RepositionCostReal: RepositionCostReal,
        LiquidCostReal: LiquidCostReal,
        CFOP: CFOP,
        CSTPisCofins: CSTPisCofins,
        NatureOperationCodePisCofins: NatureOperationCodePisCofins,
        SocialContributionCodePisCofins: SocialContributionCodePisCofins,
        IcmsFiscalAdjustCode: IcmsFiscalAdjustCode,
        IcmsFiscalAdjustObservationCode: IcmsFiscalAdjustObservationCode,
        IcmsFiscalOriginalAliquot: IcmsFiscalOriginalAliquot,
        IcmsFiscalBenefitCode: IcmsFiscalBenefitCode,
        SaleOfferCode: SaleOfferCode,
        SaleOfferQuantity: SaleOfferQuantity,
        SaleOfferDiscountType: SaleOfferDiscountType,
        SaleOfferDiscountValue: SaleOfferDiscountValue,
      );

  factory SaleMovementProductConcentratorModel.fromEntity(
          SaleMovementProductConcentratorEntity entity) =>
      SaleMovementProductConcentratorModel(
        SaleMovementProductId: entity.SaleMovementProductId,
        Position: entity.Position,
        SaleRequestProductInternalCodeOnERP:
            entity.SaleRequestProductInternalCodeOnERP,
        UnitValue: entity.UnitValue,
        Quantity: entity.Quantity,
        IsCancelled: entity.IsCancelled,
        IsToDelivery: entity.IsToDelivery,
        IsPrinted: entity.IsPrinted,
        Comments: entity.Comments,
        MotiveJustificationId: entity.MotiveJustificationId,
        MotiveJustificationName: entity.MotiveJustificationName,
        MotiveJustificationSaleDiscountId:
            entity.MotiveJustificationSaleDiscountId,
        MotiveJustificationSaleDiscountName:
            entity.MotiveJustificationSaleDiscountName,
        UserIdOfCancellation: entity.UserIdOfCancellation,
        DiscountType: entity.DiscountType,
        DiscountValue: entity.DiscountValue,
        UserIdOfDiscount: entity.UserIdOfDiscount,
        SaleNegotiationDiscountType: entity.SaleNegotiationDiscountType,
        SaleNegotiationDiscountValue: entity.SaleNegotiationDiscountValue,
        CRMDiscountType: entity.CRMDiscountType,
        CRMDiscountValue: entity.CRMDiscountValue,
        IncrementType: entity.IncrementType,
        IncrementValue: entity.IncrementValue,
        DeliveryTaxType: entity.DeliveryTaxType,
        DeliveryTaxValue: entity.DeliveryTaxValue,
        ProductPluCode: entity.ProductPluCode,
        ProductEan: entity.ProductEan,
        ProductInternalCodeOnERP: entity.ProductInternalCodeOnERP,
        ProductName: entity.ProductName,
        ProductIsFatherComposition: entity.ProductIsFatherComposition,
        SaleMovementProductCompositionId:
            entity.SaleMovementProductCompositionId,
        IcmsTributarySituationCode: entity.IcmsTributarySituationCode,
        IcmsAliquot: entity.IcmsAliquot,
        IcmsStave: entity.IcmsStave,
        IcmsReductionMargin: entity.IcmsReductionMargin,
        IcmsIVAMargin: entity.IcmsIVAMargin,
        PisType: entity.PisType,
        CofinsType: entity.CofinsType,
        PisPercentage: entity.PisPercentage,
        CofinsPercentage: entity.CofinsPercentage,
        SaleRetailPrice: entity.SaleRetailPrice,
        OfferRetailPrice: entity.OfferRetailPrice,
        WholeSalePrice: entity.WholeSalePrice,
        WholeOfferPrice: entity.WholeOfferPrice,
        SaleECommercePrice: entity.SaleECommercePrice,
        OfferECommercePrice: entity.OfferECommercePrice,
        RepositionCost: entity.RepositionCost,
        RepositionCostMiddle: entity.RepositionCostMiddle,
        LiquidCost: entity.LiquidCost,
        LiquidCostMiddle: entity.LiquidCostMiddle,
        RepositionCostReal: entity.RepositionCostReal,
        LiquidCostReal: entity.LiquidCostReal,
        CFOP: entity.CFOP,
        CSTPisCofins: entity.CSTPisCofins,
        NatureOperationCodePisCofins: entity.NatureOperationCodePisCofins,
        SocialContributionCodePisCofins: entity.SocialContributionCodePisCofins,
        IcmsFiscalAdjustCode: entity.IcmsFiscalAdjustCode,
        IcmsFiscalAdjustObservationCode: entity.IcmsFiscalAdjustObservationCode,
        IcmsFiscalOriginalAliquot: entity.IcmsFiscalOriginalAliquot,
        IcmsFiscalBenefitCode: entity.IcmsFiscalBenefitCode,
        SaleOfferCode: entity.SaleOfferCode,
        SaleOfferQuantity: entity.SaleOfferQuantity,
        SaleOfferDiscountType: entity.SaleOfferDiscountType,
        SaleOfferDiscountValue: entity.SaleOfferDiscountValue,
      );
}
