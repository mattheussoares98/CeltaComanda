class ProductEntity {
  final int productsId;
  final int? internalCodeOnERP;
  final int? internalCodeOfProductOnERP;
  final int? enterpriseId;
  final int? packingQuantity;
  final int? offerRetailPrice;
  final int? wholeSalePrice;
  final int? wholeOfferPrice;
  final int? offerECommercePrice;
  final int? saleECommercePrice;
  final int? liquidCost;
  final int? liquidCostMiddle;
  final int? liquidCostReal;
  final int? repositionCost;
  final int? repositionCostMiddle;
  final int? repositionCostReal;
  final int? icmsAliquot;
  final int? icmsIVAMargin;
  final int? icmsReductionMargin;
  final int? icmsStave;
  final int? percImpNBPTState;
  final int? percImpNBPTMunicipal;
  final int? cofinsType;
  final int? pisType;
  final int? productIsFatherComposition;
  final int? quantityMinimumWholeSale;
  final int? quantityMinimumWholeSaleByClass;
  final int? balanceTare;
  final int? familyCode;
  final int? departmentCode;
  final int? sectionCode;
  final int? groupCode;
  final int? subGroupCode;
  final int? stockQuantity;

  final bool? allowFractionate;
  final bool? isBalance;
  final bool? canBeWeightyInPdv;
  final bool? quantityInBalance;
  final bool? allowQuantityInPdv;
  final bool? goesForFastTable;
  final bool? isAlcoholicProduct;

  final double? saleRetailPrice;
  final double? percImpNBPTNational;
  final double saleRetailPraticed;
  final double? cofinsPercentage;
  final double? pisPercentage;

  final String? cFOP;
  final String? fiscalClassificationNCM;
  final String? tributarySituationCode;
  final String? cSTPisCofins;
  final String? codeClass;
  final String? departmentName;
  final String? sectionName;
  final String? dateOfLastChanged;
  final String? groupName;
  final String? saleRetailPraticedString;
  final String priceLookupCode;
  final String? personalizedCode;
  final String? eanCode;
  final String name;
  final String? nameComplete;
  final String? nameReduced;
  final String packingAbbreviation;

  ProductEntity({
    required this.packingAbbreviation,
    required this.saleRetailPraticed,
    required this.name,
    required this.priceLookupCode,
    required this.productsId,
    this.internalCodeOnERP,
    this.internalCodeOfProductOnERP,
    this.enterpriseId,
    this.personalizedCode,
    this.eanCode,
    this.nameComplete,
    this.nameReduced,
    this.packingQuantity,
    this.saleRetailPrice,
    this.offerRetailPrice,
    this.wholeSalePrice,
    this.wholeOfferPrice,
    this.offerECommercePrice,
    this.saleECommercePrice,
    this.liquidCost,
    this.liquidCostMiddle,
    this.liquidCostReal,
    this.repositionCost,
    this.repositionCostMiddle,
    this.repositionCostReal,
    this.cFOP,
    this.fiscalClassificationNCM,
    this.tributarySituationCode,
    this.icmsAliquot,
    this.icmsIVAMargin,
    this.icmsReductionMargin,
    this.icmsStave,
    this.percImpNBPTNational,
    this.percImpNBPTState,
    this.percImpNBPTMunicipal,
    this.cofinsPercentage,
    this.pisPercentage,
    this.cofinsType,
    this.pisType,
    this.cSTPisCofins,
    this.productIsFatherComposition,
    this.quantityMinimumWholeSale,
    this.quantityMinimumWholeSaleByClass,
    this.allowFractionate,
    this.isBalance,
    this.canBeWeightyInPdv,
    this.quantityInBalance,
    this.allowQuantityInPdv,
    this.goesForFastTable,
    this.isAlcoholicProduct,
    this.balanceTare,
    this.codeClass,
    this.familyCode,
    this.departmentCode,
    this.departmentName,
    this.sectionCode,
    this.sectionName,
    this.groupCode,
    this.groupName,
    this.subGroupCode,
    this.dateOfLastChanged,
    this.stockQuantity,
    this.saleRetailPraticedString,
  });
}
