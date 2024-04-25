// ignore_for_file: non_constant_identifier_names

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class PrintedProductViewModel extends Equatable {
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
  final String? PameReduced;
  final String PackingAbbreviation;

  const PrintedProductViewModel({
    required this.ProductsId,
    required this.SaleRetailPraticed,
    required this.PriceLookupCode,
    required this.PackingAbbreviation,
    required this.Name,
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
    this.PameReduced,
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
        PameReduced,
      ];

  factory PrintedProductViewModel.fromEntity(PrintedProductsEntity entity) =>
      PrintedProductViewModel(
        ProductsId: entity.Product.ProductsId.toString(),
        InternalCodeOnERP: entity.Product.InternalCodeOnERP.toString(),
        InternalCodeOfProductOnERP:
            entity.Product.InternalCodeOfProductOnERP.toString(),
        EenterpriseId: entity.Product.EenterpriseId.toString(),
        PriceLookupCode: entity.Product.PriceLookupCode,
        PackingAbbreviation: entity.Product.PackingAbbreviation,
        Name: entity.Product.Name,
        SaleRetailPraticed: entity.Product.SaleRetailPraticed.toString(),
        PackingQuantity: entity.Product.PackingQuantity.toString(),
        OfferRetailPrice: entity.Product.OfferRetailPrice.toString(),
        WholeSalePrice: entity.Product.WholeSalePrice.toString(),
        WholeOfferPrice: entity.Product.WholeOfferPrice.toString(),
        OfferECommercePrice: entity.Product.OfferECommercePrice.toString(),
        SaleECommercePrice: entity.Product.SaleECommercePrice.toString(),
        LiquidCost: entity.Product.LiquidCost.toString(),
        LiquidCostMiddle: entity.Product.LiquidCostMiddle.toString(),
        LiquidCostReal: entity.Product.LiquidCostReal.toString(),
        RepositionCost: entity.Product.RepositionCost.toString(),
        RepositionCostMiddle: entity.Product.RepositionCostMiddle.toString(),
        RepositionCostReal: entity.Product.RepositionCostReal.toString(),
        IcmsAliquot: entity.Product.IcmsAliquot.toString(),
        IcmsIVAMargin: entity.Product.IcmsIVAMargin.toString(),
        IcmsReductionMargin: entity.Product.IcmsReductionMargin.toString(),
        IcmsStave: entity.Product.IcmsStave.toString(),
        PercImpNBPTState: entity.Product.PercImpNBPTState.toString(),
        PercImpNBPTMunicipal: entity.Product.PercImpNBPTMunicipal.toString(),
        QuantityMinimumWholeSale:
            entity.Product.QuantityMinimumWholeSale.toString(),
        QuantityMinimumWholeSaleByClass:
            entity.Product.QuantityMinimumWholeSaleByClass.toString(),
        BalanceTare: entity.Product.BalanceTare.toString(),
        StockQuantity: entity.Product.StockQuantity.toString(),
        SaleRetailPrice: entity.Product.SaleRetailPrice.toString(),
        PercImpNBPTNational: entity.Product.PercImpNBPTNational.toString(),
        CofinsPercentage: entity.Product.CofinsPercentage.toString(),
        PisPercentage: entity.Product.PisPercentage.toString(),
        CofinsType: entity.Product.CofinsType.toString(),
        PisType: entity.Product.PisType.toString(),
        ProductIsFatherComposition:
            entity.Product.ProductIsFatherComposition.toString(),
        FamilyCode: entity.Product.FamilyCode.toString(),
        DepartmentCode: entity.Product.DepartmentCode.toString(),
        SectionCode: entity.Product.SectionCode.toString(),
        GroupCode: entity.Product.GroupCode.toString(),
        SubGroupCode: entity.Product.SubGroupCode.toString(),
        AllowFractionate: entity.Product.AllowFractionate.toString(),
        IsBalance: entity.Product.IsBalance.toString(),
        CanBeWeightyInPdv: entity.Product.CanBeWeightyInPdv.toString(),
        QuantityInBalance: entity.Product.QuantityInBalance.toString(),
        AllowQuantityInPdv: entity.Product.AllowQuantityInPdv.toString(),
        GoesForFastTable: entity.Product.GoesForFastTable.toString(),
        IsAlcoholicProduct: entity.Product.IsAlcoholicProduct.toString(),
        CFOP: entity.Product.CFOP,
        FiscalClassificationNCM: entity.Product.FiscalClassificationNCM,
        TributarySituationCode: entity.Product.TributarySituationCode,
        CSTPisCofins: entity.Product.CSTPisCofins,
        CodeClass: entity.Product.CodeClass,
        DepartmentName: entity.Product.DepartmentName,
        SectionName: entity.Product.SectionName,
        DateOfLastChanged: entity.Product.DateOfLastChanged,
        GroupName: entity.Product.GroupName,
        SaleRetailPraticedString: entity.Product.SaleRetailPraticedString,
        PersonalizedCode: entity.Product.PersonalizedCode,
        EanCode: entity.Product.EanCode,
        NameComplete: entity.Product.NameComplete,
        PameReduced: entity.Product.NameReduced,
      );
}
