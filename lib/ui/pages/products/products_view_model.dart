// ignore_for_file: non_constant_identifier_names

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class ProductsViewModel extends Equatable {
  final String ProductsId;
  final String? InternalCodeOnERP;
  final String? InternalCodeOfProductOnERP;
  final String? EenterpriseId;
  final String? PackingQuantity;
  final String? OfferRetailPrice;
  final String? WholeSalePrice;
  final String? WholeOfferPrice;
  final String? OfferECommercePrice;
  final String? SaleECommercePrice;
  final String? LiquidCost;
  final String? LiquidCostMiddle;
  final String? LiquidCostReal;
  final String? RepositionCost;
  final String? RepositionCostMiddle;
  final String? RepositionCostReal;
  final String? IcmsAliquot;
  final String? IcmsIVAMargin;
  final String? IcmsReductionMargin;
  final String? IcmsStave;
  final String? PercImpNBPTState;
  final String? PercImpNBPTMunicipal;
  final String? CofinsType;
  final String? PisType;
  final String? ProductIsFatherComposition;
  final String? QuantityMinimumWholeSale;
  final String? QuantityMinimumWholeSaleByClass;
  final String? BalanceTare;
  final String? FamilyCode;
  final String? DepartmentCode;
  final String? SectionCode;
  final String? GroupCode;
  final String? SubGroupCode;
  final String? StockQuantity;
  final String? AllowFractionate;
  final String? IsBalance;
  final String? CanBeWeightyInPdv;
  final String? QuantityInBalance;
  final String? AllowQuantityInPdv;
  final String? GoesForFastTable;
  final String? IsAlcoholicProduct;
  final String? SaleRetailPrice;
  final String? PercImpNBPTNational;
  final String SaleRetailPraticed;
  final String? CofinsPercentage;
  final String? PisPercentage;
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

  const ProductsViewModel({
    required this.ProductsId,
    required this.SaleRetailPraticed,
    required this.PriceLookupCode,
    required this.Name,
    required this.PackingAbbreviation,
    this.InternalCodeOnERP,
    this.InternalCodeOfProductOnERP,
    this.EenterpriseId,
    this.PackingQuantity,
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
    this.IcmsAliquot,
    this.IcmsIVAMargin,
    this.IcmsReductionMargin,
    this.IcmsStave,
    this.PercImpNBPTState,
    this.PercImpNBPTMunicipal,
    this.CofinsType,
    this.PisType,
    this.ProductIsFatherComposition,
    this.QuantityMinimumWholeSale,
    this.QuantityMinimumWholeSaleByClass,
    this.BalanceTare,
    this.FamilyCode,
    this.DepartmentCode,
    this.SectionCode,
    this.GroupCode,
    this.SubGroupCode,
    this.StockQuantity,
    this.AllowFractionate,
    this.IsBalance,
    this.CanBeWeightyInPdv,
    this.QuantityInBalance,
    this.AllowQuantityInPdv,
    this.GoesForFastTable,
    this.IsAlcoholicProduct,
    this.SaleRetailPrice,
    this.PercImpNBPTNational,
    this.CofinsPercentage,
    this.PisPercentage,
    this.CFOP,
    this.FiscalClassificationNCM,
    this.TributarySituationCode,
    this.CSTPisCofins,
    this.CodeClass,
    this.DepartmentName,
    this.SectionName,
    this.DateOfLastChanged,
    this.GroupName,
    this.SaleRetailPraticedString,
    this.PersonalizedCode,
    this.EanCode,
    this.NameComplete,
    this.NameReduced,
  });

  @override
  List<Object?> get props => [
        ProductsId,
        SaleRetailPraticed,
        PriceLookupCode,
        PackingAbbreviation,
        Name,
        InternalCodeOnERP,
        InternalCodeOfProductOnERP,
        EenterpriseId,
        PackingQuantity,
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
        IcmsAliquot,
        IcmsIVAMargin,
        IcmsReductionMargin,
        IcmsStave,
        PercImpNBPTState,
        PercImpNBPTMunicipal,
        CofinsType,
        PisType,
        ProductIsFatherComposition,
        QuantityMinimumWholeSale,
        QuantityMinimumWholeSaleByClass,
        BalanceTare,
        FamilyCode,
        DepartmentCode,
        SectionCode,
        GroupCode,
        SubGroupCode,
        StockQuantity,
        AllowFractionate,
        IsBalance,
        CanBeWeightyInPdv,
        QuantityInBalance,
        AllowQuantityInPdv,
        GoesForFastTable,
        IsAlcoholicProduct,
        SaleRetailPrice,
        PercImpNBPTNational,
        CofinsPercentage,
        PisPercentage,
        CFOP,
        FiscalClassificationNCM,
        TributarySituationCode,
        CSTPisCofins,
        CodeClass,
        DepartmentName,
        SectionName,
        DateOfLastChanged,
        GroupName,
        SaleRetailPraticedString,
        PersonalizedCode,
        EanCode,
        NameComplete,
        NameReduced,
      ];

  factory ProductsViewModel.fromEntity(ProductEntity entity) =>
      ProductsViewModel(
        ProductsId: entity.ProductsId.toString(),
        InternalCodeOnERP: entity.InternalCodeOnERP.toString(),
        InternalCodeOfProductOnERP:
            entity.InternalCodeOfProductOnERP.toString(),
        EenterpriseId: entity.EenterpriseId.toString(),
        PackingQuantity: entity.PackingQuantity.toString(),
        OfferRetailPrice: entity.OfferRetailPrice.toString(),
        WholeSalePrice: entity.WholeSalePrice.toString(),
        WholeOfferPrice: entity.WholeOfferPrice.toString(),
        OfferECommercePrice: entity.OfferECommercePrice.toString(),
        SaleECommercePrice: entity.SaleECommercePrice.toString(),
        LiquidCost: entity.LiquidCost.toString(),
        LiquidCostMiddle: entity.LiquidCostMiddle.toString(),
        LiquidCostReal: entity.LiquidCostReal.toString(),
        RepositionCost: entity.RepositionCost.toString(),
        RepositionCostMiddle: entity.RepositionCostMiddle.toString(),
        RepositionCostReal: entity.RepositionCostReal.toString(),
        IcmsAliquot: entity.IcmsAliquot.toString(),
        IcmsIVAMargin: entity.IcmsIVAMargin.toString(),
        IcmsReductionMargin: entity.IcmsReductionMargin.toString(),
        IcmsStave: entity.IcmsStave.toString(),
        PercImpNBPTState: entity.PercImpNBPTState.toString(),
        PercImpNBPTMunicipal: entity.PercImpNBPTMunicipal.toString(),
        CofinsType: entity.CofinsType.toString(),
        PisType: entity.PisType.toString(),
        ProductIsFatherComposition:
            entity.ProductIsFatherComposition.toString(),
        QuantityMinimumWholeSale: entity.QuantityMinimumWholeSale.toString(),
        QuantityMinimumWholeSaleByClass:
            entity.QuantityMinimumWholeSaleByClass.toString(),
        BalanceTare: entity.BalanceTare.toString(),
        FamilyCode: entity.FamilyCode.toString(),
        DepartmentCode: entity.DepartmentCode.toString(),
        SectionCode: entity.SectionCode.toString(),
        GroupCode: entity.GroupCode.toString(),
        SubGroupCode: entity.SubGroupCode.toString(),
        StockQuantity: entity.StockQuantity.toString(),
        AllowFractionate: entity.AllowFractionate.toString(),
        IsBalance: entity.IsBalance.toString(),
        CanBeWeightyInPdv: entity.CanBeWeightyInPdv.toString(),
        QuantityInBalance: entity.QuantityInBalance.toString(),
        AllowQuantityInPdv: entity.AllowQuantityInPdv.toString(),
        GoesForFastTable: entity.GoesForFastTable.toString(),
        IsAlcoholicProduct: entity.IsAlcoholicProduct.toString(),
        SaleRetailPrice: entity.SaleRetailPrice.toString(),
        PercImpNBPTNational: entity.PercImpNBPTNational.toString(),
        SaleRetailPraticed: entity.SaleRetailPraticed.toString(),
        CofinsPercentage: entity.CofinsPercentage.toString(),
        PisPercentage: entity.PisPercentage.toString(),
        CFOP: entity.CFOP,
        FiscalClassificationNCM: entity.FiscalClassificationNCM,
        TributarySituationCode: entity.TributarySituationCode,
        CSTPisCofins: entity.CSTPisCofins,
        CodeClass: entity.CodeClass,
        DepartmentName: entity.DepartmentName,
        SectionName: entity.SectionName,
        DateOfLastChanged: entity.DateOfLastChanged,
        GroupName: entity.GroupName,
        SaleRetailPraticedString: entity.SaleRetailPraticedString,
        PriceLookupCode: entity.PriceLookupCode,
        PersonalizedCode: entity.PersonalizedCode,
        EanCode: entity.EanCode,
        Name: entity.Name,
        NameComplete: entity.NameComplete,
        NameReduced: entity.NameReduced,
        PackingAbbreviation: entity.PackingAbbreviation,
      );
}
