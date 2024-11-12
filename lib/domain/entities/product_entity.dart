// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class ProductEntity extends Equatable {
  final int ProductsId;
  final int? InternalCodeOnERP;
  final int? InternalCodeOfProductOnERP;
  final int? EenterpriseId;
  final double? PackingQuantity;
  final double? OfferRetailPrice;
  final double? WholeSalePrice;
  final double? WholeOfferPrice;
  final double? OfferECommercePrice;
  final double? SaleECommercePrice;
  final double? LiquidCost;
  final double? LiquidCostMiddle;
  final double? LiquidCostReal;
  final double? RepositionCost;
  final double? RepositionCostMiddle;
  final double? RepositionCostReal;
  final double? IcmsAliquot;
  final double? IcmsIVAMargin;
  final double? IcmsReductionMargin;
  final double? IcmsStave;
  final double? PercImpNBPTState;
  final double? PercImpNBPTMunicipal;
  final int? CofinsType;
  final int? PisType;
  final int? ProductIsFatherComposition;
  final double? QuantityMinimumWholeSale;
  final double? QuantityMinimumWholeSaleByClass;
  final double? BalanceTare;
  final int? FamilyCode;
  final int? DepartmentCode;
  final int? SectionCode;
  final int? GroupCode;
  final int? SubGroupCode;
  final double? StockQuantity;

  final bool? AllowFractionate;
  final bool? IsBalance;
  final bool? CanBeWeightyInPdv;
  final bool? QuantityInBalance;
  final bool? AllowQuantityInPdv;
  final bool? GoesForFastTable;
  final bool? IsAlcoholicProduct;
  final bool? IsPromoCombox;

  final double? SaleRetailPrice;
  final double? PercImpNBPTNational;
  final double SaleRetailPraticed;
  final double? CofinsPercentage;
  final double? PisPercentage;
  final double? MaximumQuantityForSale;

  final String? CFOP;
  final String? FiscalClassificationNCM;
  final String? TributarySituationCode;
  final String? CSTPisCofins;
  final String? CodeClass;
  final String? DepartmentName;
  final String? SectionName;
  final String? DateOfLastChanged;
  final String? GroupName;
  final String? SaleRetailPraticedString;
  final String PriceLookupCode;
  final String? PersonalizedCode;
  final String? EanCode;
  final String Name;
  final String? NameComplete;
  final String? NameReduced;
  final String? ProductComplement;
  final String PackingAbbreviation;
  final List<ProductCompositionEntity>? childsComposition;
  final ProductScheduleEntity? Schedule;

  const ProductEntity({
    required this.PackingAbbreviation,
    required this.SaleRetailPraticed,
    required this.Name,
    required this.PriceLookupCode,
    required this.ProductsId,
    required this.IsPromoCombox,
    required this.InternalCodeOnERP,
    required this.InternalCodeOfProductOnERP,
    required this.EenterpriseId,
    required this.PersonalizedCode,
    required this.EanCode,
    required this.NameComplete,
    required this.NameReduced,
    required this.PackingQuantity,
    required this.SaleRetailPrice,
    required this.OfferRetailPrice,
    required this.WholeSalePrice,
    required this.WholeOfferPrice,
    required this.OfferECommercePrice,
    required this.SaleECommercePrice,
    required this.LiquidCost,
    required this.LiquidCostMiddle,
    required this.LiquidCostReal,
    required this.RepositionCost,
    required this.RepositionCostMiddle,
    required this.RepositionCostReal,
    required this.CFOP,
    required this.FiscalClassificationNCM,
    required this.TributarySituationCode,
    required this.IcmsAliquot,
    required this.IcmsIVAMargin,
    required this.IcmsReductionMargin,
    required this.IcmsStave,
    required this.PercImpNBPTNational,
    required this.PercImpNBPTState,
    required this.PercImpNBPTMunicipal,
    required this.CofinsPercentage,
    required this.PisPercentage,
    required this.CofinsType,
    required this.PisType,
    required this.CSTPisCofins,
    required this.ProductIsFatherComposition,
    required this.QuantityMinimumWholeSale,
    required this.QuantityMinimumWholeSaleByClass,
    required this.AllowFractionate,
    required this.IsBalance,
    required this.CanBeWeightyInPdv,
    required this.QuantityInBalance,
    required this.AllowQuantityInPdv,
    required this.GoesForFastTable,
    required this.IsAlcoholicProduct,
    required this.BalanceTare,
    required this.CodeClass,
    required this.FamilyCode,
    required this.DepartmentCode,
    required this.DepartmentName,
    required this.SectionCode,
    required this.SectionName,
    required this.GroupCode,
    required this.GroupName,
    required this.SubGroupCode,
    required this.DateOfLastChanged,
    required this.StockQuantity,
    required this.ProductComplement,
    required this.SaleRetailPraticedString,
    required this.childsComposition,
    required this.MaximumQuantityForSale,
    required this.Schedule,
  });

  @override
  List<Object?> get props => [
        PackingAbbreviation,
        SaleRetailPraticed,
        Name,
        PriceLookupCode,
        ProductsId,
        IsPromoCombox,
        InternalCodeOnERP,
        InternalCodeOfProductOnERP,
        EenterpriseId,
        PersonalizedCode,
        EanCode,
        NameComplete,
        NameReduced,
        PackingQuantity,
        SaleRetailPrice,
        OfferRetailPrice,
        WholeSalePrice,
        WholeOfferPrice,
        OfferECommercePrice,
        SaleECommercePrice,
        LiquidCost,
        LiquidCostMiddle,
        LiquidCostReal,
        RepositionCost,
        RepositionCostMiddle,
        RepositionCostReal,
        CFOP,
        FiscalClassificationNCM,
        TributarySituationCode,
        IcmsAliquot,
        IcmsIVAMargin,
        IcmsReductionMargin,
        IcmsStave,
        PercImpNBPTNational,
        PercImpNBPTState,
        PercImpNBPTMunicipal,
        CofinsPercentage,
        PisPercentage,
        CofinsType,
        PisType,
        CSTPisCofins,
        ProductIsFatherComposition,
        QuantityMinimumWholeSale,
        QuantityMinimumWholeSaleByClass,
        AllowFractionate,
        IsBalance,
        CanBeWeightyInPdv,
        QuantityInBalance,
        AllowQuantityInPdv,
        GoesForFastTable,
        IsAlcoholicProduct,
        BalanceTare,
        CodeClass,
        FamilyCode,
        DepartmentCode,
        DepartmentName,
        SectionCode,
        SectionName,
        GroupCode,
        GroupName,
        SubGroupCode,
        DateOfLastChanged,
        StockQuantity,
        SaleRetailPraticedString,
        ProductComplement,
        childsComposition,
        MaximumQuantityForSale,
        Schedule,
      ];
}
