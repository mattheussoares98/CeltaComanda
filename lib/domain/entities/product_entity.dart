// ignore_for_file: non_constant_identifier_names

class ProductEntity {
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

  final double? SaleRetailPrice;
  final double? PercImpNBPTNational;
  final double SaleRetailPraticed;
  final double? CofinsPercentage;
  final double? PisPercentage;

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
  final String PackingAbbreviation;

  ProductEntity({
    required this.PackingAbbreviation,
    required this.SaleRetailPraticed,
    required this.Name,
    required this.PriceLookupCode,
    required this.ProductsId,
    this.InternalCodeOnERP,
    this.InternalCodeOfProductOnERP,
    this.EenterpriseId,
    this.PersonalizedCode,
    this.EanCode,
    this.NameComplete,
    this.NameReduced,
    this.PackingQuantity,
    this.SaleRetailPrice,
    this.OfferRetailPrice,
    this.WholeSalePrice,
    this.WholeOfferPrice,
    this.OfferECommercePrice,
    this.SaleECommercePrice,
    this.LiquidCost,
    this.LiquidCostMiddle,
    this.LiquidCostReal,
    this.RepositionCost,
    this.RepositionCostMiddle,
    this.RepositionCostReal,
    this.CFOP,
    this.FiscalClassificationNCM,
    this.TributarySituationCode,
    this.IcmsAliquot,
    this.IcmsIVAMargin,
    this.IcmsReductionMargin,
    this.IcmsStave,
    this.PercImpNBPTNational,
    this.PercImpNBPTState,
    this.PercImpNBPTMunicipal,
    this.CofinsPercentage,
    this.PisPercentage,
    this.CofinsType,
    this.PisType,
    this.CSTPisCofins,
    this.ProductIsFatherComposition,
    this.QuantityMinimumWholeSale,
    this.QuantityMinimumWholeSaleByClass,
    this.AllowFractionate,
    this.IsBalance,
    this.CanBeWeightyInPdv,
    this.QuantityInBalance,
    this.AllowQuantityInPdv,
    this.GoesForFastTable,
    this.IsAlcoholicProduct,
    this.BalanceTare,
    this.CodeClass,
    this.FamilyCode,
    this.DepartmentCode,
    this.DepartmentName,
    this.SectionCode,
    this.SectionName,
    this.GroupCode,
    this.GroupName,
    this.SubGroupCode,
    this.DateOfLastChanged,
    this.StockQuantity,
    this.SaleRetailPraticedString,
  });
}
