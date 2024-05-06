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
        PriceLookupCode: entity.PriceLookupCode,
        Name: entity.Name,
        PackingAbbreviation: entity.PackingAbbreviation,
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
        PersonalizedCode: entity.PersonalizedCode,
        EanCode: entity.EanCode,
        NameComplete: entity.NameComplete,
        NameReduced: entity.NameReduced,
        ProductsId: entity.ProductsId.toString(),
        SaleRetailPrice: entity.SaleRetailPrice?.toStringAsFixed(2)
            .replaceAll(RegExp(r'\.'), ','),
        SaleRetailPraticed: entity.SaleRetailPraticed.toStringAsFixed(2)
            .replaceAll(RegExp(r'\.'), ','),
        InternalCodeOnERP: entity.InternalCodeOnERP.toString(),
        InternalCodeOfProductOnERP:
            entity.InternalCodeOfProductOnERP.toString(),
        EenterpriseId: entity.EenterpriseId.toString(),
        PackingQuantity: entity.PackingQuantity.toString(),
        OfferRetailPrice: entity.OfferRetailPrice?.toStringAsFixed(2)
            .replaceAll(RegExp(r'\.'), ','),
        WholeSalePrice: entity.WholeSalePrice?.toStringAsFixed(2)
            .replaceAll(RegExp(r'\.'), ','),
        WholeOfferPrice: entity.WholeOfferPrice?.toStringAsFixed(2)
            .replaceAll(RegExp(r'\.'), ','),
        OfferECommercePrice: entity.OfferECommercePrice?.toStringAsFixed(2)
            .replaceAll(RegExp(r'\.'), ','),
        SaleECommercePrice: entity.SaleECommercePrice?.toStringAsFixed(2)
            .replaceAll(RegExp(r'\.'), ','),
        LiquidCost: entity.LiquidCost?.toStringAsFixed(2)
            .replaceAll(RegExp(r'\.'), ','),
        LiquidCostMiddle: entity.LiquidCostMiddle?.toStringAsFixed(2)
            .replaceAll(RegExp(r'\.'), ','),
        LiquidCostReal: entity.LiquidCostReal?.toStringAsFixed(2)
            .replaceAll(RegExp(r'\.'), ','),
        RepositionCost: entity.RepositionCost?.toStringAsFixed(2)
            .replaceAll(RegExp(r'\.'), ','),
        RepositionCostMiddle: entity.RepositionCostMiddle?.toStringAsFixed(2)
            .replaceAll(RegExp(r'\.'), ','),
        RepositionCostReal: entity.RepositionCostReal?.toStringAsFixed(2)
            .replaceAll(RegExp(r'\.'), ','),
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
        PercImpNBPTNational: entity.PercImpNBPTNational.toString(),
        CofinsPercentage: entity.CofinsPercentage.toString(),
        PisPercentage: entity.PisPercentage.toString(),
      );

  ProductEntity toEntity() => ProductEntity(
        Name: Name,
        CFOP: CFOP,
        ProductsId: int.parse(ProductsId),
        InternalCodeOnERP: int.tryParse(InternalCodeOnERP.toString()),
        InternalCodeOfProductOnERP:
            int.tryParse(InternalCodeOfProductOnERP.toString()),
        EenterpriseId: int.tryParse(EenterpriseId.toString()),
        PackingQuantity: _convertToDouble(PackingQuantity),
        OfferRetailPrice: _convertToDouble(OfferRetailPrice),
        WholeSalePrice: _convertToDouble(WholeSalePrice),
        WholeOfferPrice: _convertToDouble(WholeOfferPrice),
        OfferECommercePrice: _convertToDouble(OfferECommercePrice),
        SaleECommercePrice: _convertToDouble(SaleECommercePrice),
        LiquidCost: _convertToDouble(LiquidCost),
        LiquidCostMiddle: _convertToDouble(LiquidCostMiddle),
        LiquidCostReal: _convertToDouble(LiquidCostReal),
        RepositionCost: _convertToDouble(RepositionCost),
        RepositionCostMiddle: _convertToDouble(RepositionCostMiddle),
        RepositionCostReal: _convertToDouble(RepositionCostReal),
        IcmsAliquot: _convertToDouble(IcmsAliquot),
        IcmsIVAMargin: _convertToDouble(IcmsIVAMargin),
        IcmsReductionMargin: _convertToDouble(IcmsReductionMargin),
        IcmsStave: _convertToDouble(IcmsStave),
        PercImpNBPTState: _convertToDouble(PercImpNBPTState),
        PercImpNBPTMunicipal: _convertToDouble(PercImpNBPTMunicipal),
        CofinsType: int.tryParse(CofinsType.toString()),
        PisType: int.tryParse(PisType.toString()),
        ProductIsFatherComposition:
            int.tryParse(ProductIsFatherComposition.toString()),
        QuantityMinimumWholeSale: _convertToDouble(QuantityMinimumWholeSale),
        QuantityMinimumWholeSaleByClass:
            _convertToDouble(QuantityMinimumWholeSaleByClass),
        FamilyCode: int.tryParse(FamilyCode.toString()),
        BalanceTare: _convertToDouble(BalanceTare),
        DepartmentCode: int.tryParse(DepartmentCode.toString()),
        SectionCode: int.tryParse(SectionCode.toString()),
        GroupCode: int.tryParse(GroupCode.toString()),
        SubGroupCode: int.tryParse(SubGroupCode.toString()),
        StockQuantity: _convertToDouble(StockQuantity),
        AllowFractionate: bool.parse(AllowFractionate.toString()),
        IsBalance: bool.parse(IsBalance.toString()),
        CanBeWeightyInPdv: bool.parse(CanBeWeightyInPdv.toString()),
        QuantityInBalance: bool.parse(QuantityInBalance.toString()),
        AllowQuantityInPdv: bool.parse(AllowQuantityInPdv.toString()),
        GoesForFastTable: bool.parse(GoesForFastTable.toString()),
        IsAlcoholicProduct: bool.parse(IsAlcoholicProduct.toString()),
        SaleRetailPrice: _convertToDouble(SaleRetailPrice),
        PercImpNBPTNational: _convertToDouble(PercImpNBPTNational),
        SaleRetailPraticed: double.parse(
            SaleRetailPraticed.toString().replaceAll(RegExp(r','), '.')),
        CofinsPercentage: _convertToDouble(CofinsPercentage),
        PisPercentage: _convertToDouble(PisPercentage),
        FiscalClassificationNCM: FiscalClassificationNCM,
        TributarySituationCode: TributarySituationCode,
        CSTPisCofins: CSTPisCofins,
        CodeClass: CodeClass,
        DepartmentName: DepartmentName,
        SectionName: SectionName,
        DateOfLastChanged: DateOfLastChanged,
        GroupName: GroupName,
        SaleRetailPraticedString: SaleRetailPraticedString,
        PriceLookupCode: PriceLookupCode,
        PersonalizedCode: PersonalizedCode,
        EanCode: EanCode,
        NameComplete: NameComplete,
        NameReduced: NameReduced,
        PackingAbbreviation: PackingAbbreviation,
      );

  double? _convertToDouble(dynamic value) =>
      double.tryParse(value.toString().replaceAll(RegExp(r','), '.'));
}
