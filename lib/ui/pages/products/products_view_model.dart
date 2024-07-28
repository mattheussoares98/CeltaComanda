// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'package:equatable/equatable.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../../domain/entities/entities.dart';
import '../pages.dart';

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
  final String? ProductComplement;
  final String PackingAbbreviation;
  final String IsPromoCombox;
  List<InsertProductsViewModel>? childsComposition;
  double productQuantity;

  ProductsViewModel({
    required this.IsPromoCombox,
    required this.ProductComplement,
    required this.ProductsId,
    required this.SaleRetailPraticed,
    required this.PriceLookupCode,
    required this.Name,
    required this.PackingAbbreviation,
    required this.InternalCodeOnERP,
    required this.InternalCodeOfProductOnERP,
    required this.EenterpriseId,
    required this.PackingQuantity,
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
    required this.IcmsAliquot,
    required this.IcmsIVAMargin,
    required this.IcmsReductionMargin,
    required this.IcmsStave,
    required this.PercImpNBPTState,
    required this.PercImpNBPTMunicipal,
    required this.CofinsType,
    required this.PisType,
    required this.ProductIsFatherComposition,
    required this.QuantityMinimumWholeSale,
    required this.QuantityMinimumWholeSaleByClass,
    required this.BalanceTare,
    required this.FamilyCode,
    required this.DepartmentCode,
    required this.SectionCode,
    required this.GroupCode,
    required this.SubGroupCode,
    required this.StockQuantity,
    required this.AllowFractionate,
    required this.IsBalance,
    required this.CanBeWeightyInPdv,
    required this.QuantityInBalance,
    required this.AllowQuantityInPdv,
    required this.GoesForFastTable,
    required this.IsAlcoholicProduct,
    required this.SaleRetailPrice,
    required this.PercImpNBPTNational,
    required this.CofinsPercentage,
    required this.PisPercentage,
    required this.CFOP,
    required this.FiscalClassificationNCM,
    required this.TributarySituationCode,
    required this.CSTPisCofins,
    required this.CodeClass,
    required this.DepartmentName,
    required this.SectionName,
    required this.DateOfLastChanged,
    required this.GroupName,
    required this.SaleRetailPraticedString,
    required this.PersonalizedCode,
    required this.EanCode,
    required this.NameComplete,
    required this.NameReduced,
    this.productQuantity = 1,
    this.childsComposition,
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
        productQuantity,
        childsComposition,
      ];

  factory ProductsViewModel.fromEntity(ProductEntity entity) =>
      ProductsViewModel(
        IsPromoCombox: entity.IsPromoCombox.toString(),
        PriceLookupCode: entity.PriceLookupCode,
        ProductComplement: entity.ProductComplement,
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
        SaleRetailPrice:
            entity.SaleRetailPrice?.toStringAsFixed(2).toBrazilianNumber(),
        SaleRetailPraticed:
            entity.SaleRetailPraticed.toStringAsFixed(2).toBrazilianNumber(),
        InternalCodeOnERP: entity.InternalCodeOnERP.toString(),
        InternalCodeOfProductOnERP:
            entity.InternalCodeOfProductOnERP.toString(),
        EenterpriseId: entity.EenterpriseId.toString(),
        PackingQuantity: entity.PackingQuantity.toString(),
        OfferRetailPrice:
            entity.OfferRetailPrice?.toStringAsFixed(2).toBrazilianNumber(),
        WholeSalePrice:
            entity.WholeSalePrice?.toStringAsFixed(2).toBrazilianNumber(),
        WholeOfferPrice:
            entity.WholeOfferPrice?.toStringAsFixed(2).toBrazilianNumber(),
        OfferECommercePrice:
            entity.OfferECommercePrice?.toStringAsFixed(2).toBrazilianNumber(),
        SaleECommercePrice:
            entity.SaleECommercePrice?.toStringAsFixed(2).toBrazilianNumber(),
        LiquidCost: entity.LiquidCost?.toStringAsFixed(2).toBrazilianNumber(),
        LiquidCostMiddle:
            entity.LiquidCostMiddle?.toStringAsFixed(2).toBrazilianNumber(),
        LiquidCostReal:
            entity.LiquidCostReal?.toStringAsFixed(2).toBrazilianNumber(),
        RepositionCost:
            entity.RepositionCost?.toStringAsFixed(2).toBrazilianNumber(),
        RepositionCostMiddle:
            entity.RepositionCostMiddle?.toStringAsFixed(2).toBrazilianNumber(),
        RepositionCostReal:
            entity.RepositionCostReal?.toStringAsFixed(2).toBrazilianNumber(),
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
        ProductComplement: ProductComplement,
        IsPromoCombox: bool.parse(IsPromoCombox),
        Name: Name,
        CFOP: CFOP,
        ProductsId: int.parse(ProductsId),
        InternalCodeOnERP: int.tryParse(InternalCodeOnERP.toString()),
        InternalCodeOfProductOnERP:
            int.tryParse(InternalCodeOfProductOnERP.toString()),
        EenterpriseId: int.tryParse(EenterpriseId.toString()),
        PackingQuantity: PackingQuantity?.toDouble(),
        OfferRetailPrice: OfferRetailPrice?.toDouble(),
        WholeSalePrice: WholeSalePrice?.toDouble(),
        WholeOfferPrice: WholeOfferPrice?.toDouble(),
        OfferECommercePrice: OfferECommercePrice?.toDouble(),
        SaleECommercePrice: SaleECommercePrice?.toDouble(),
        LiquidCost: LiquidCost?.toDouble(),
        LiquidCostMiddle: LiquidCostMiddle?.toDouble(),
        LiquidCostReal: LiquidCostReal?.toDouble(),
        RepositionCost: RepositionCost?.toDouble(),
        RepositionCostMiddle: RepositionCostMiddle?.toDouble(),
        RepositionCostReal: RepositionCostReal?.toDouble(),
        IcmsAliquot: IcmsAliquot?.toDouble(),
        IcmsIVAMargin: IcmsIVAMargin?.toDouble(),
        IcmsReductionMargin: IcmsReductionMargin?.toDouble(),
        IcmsStave: IcmsStave?.toDouble(),
        PercImpNBPTState: PercImpNBPTState?.toDouble(),
        PercImpNBPTMunicipal: PercImpNBPTMunicipal?.toDouble(),
        CofinsType: int.tryParse(CofinsType.toString()),
        PisType: int.tryParse(PisType.toString()),
        ProductIsFatherComposition:
            int.tryParse(ProductIsFatherComposition.toString()),
        QuantityMinimumWholeSale: QuantityMinimumWholeSale?.toDouble(),
        QuantityMinimumWholeSaleByClass:
            QuantityMinimumWholeSaleByClass?.toDouble(),
        FamilyCode: int.tryParse(FamilyCode.toString()),
        BalanceTare: BalanceTare?.toDouble(),
        DepartmentCode: int.tryParse(DepartmentCode.toString()),
        SectionCode: int.tryParse(SectionCode.toString()),
        GroupCode: int.tryParse(GroupCode.toString()),
        SubGroupCode: int.tryParse(SubGroupCode.toString()),
        StockQuantity: StockQuantity?.toDouble(),
        AllowFractionate: bool.parse(AllowFractionate.toString()),
        IsBalance: bool.parse(IsBalance.toString()),
        CanBeWeightyInPdv: bool.parse(CanBeWeightyInPdv.toString()),
        QuantityInBalance: bool.parse(QuantityInBalance.toString()),
        AllowQuantityInPdv: bool.parse(AllowQuantityInPdv.toString()),
        GoesForFastTable: bool.parse(GoesForFastTable.toString()),
        IsAlcoholicProduct: bool.parse(IsAlcoholicProduct.toString()),
        SaleRetailPrice: SaleRetailPrice?.toDouble(),
        PercImpNBPTNational: PercImpNBPTNational?.toDouble(),
        SaleRetailPraticed: SaleRetailPraticed.toString().toDouble(),
        CofinsPercentage: CofinsPercentage?.toDouble(),
        PisPercentage: PisPercentage?.toDouble(),
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

  Map<String, dynamic> toJson() => {
        "ProductsId": ProductsId,
        "InternalCodeOnERP": InternalCodeOnERP,
        "InternalCodeOfProductOnERP": InternalCodeOfProductOnERP,
        "EenterpriseId": EenterpriseId,
        "PackingQuantity": PackingQuantity,
        "OfferRetailPrice": OfferRetailPrice,
        "WholeSalePrice": WholeSalePrice,
        "WholeOfferPrice": WholeOfferPrice,
        "OfferECommercePrice": OfferECommercePrice,
        "SaleECommercePrice": SaleECommercePrice,
        "LiquidCost": LiquidCost,
        "LiquidCostMiddle": LiquidCostMiddle,
        "LiquidCostReal": LiquidCostReal,
        "RepositionCost": RepositionCost,
        "RepositionCostMiddle": RepositionCostMiddle,
        "RepositionCostReal": RepositionCostReal,
        "IcmsAliquot": IcmsAliquot,
        "IcmsIVAMargin": IcmsIVAMargin,
        "IcmsReductionMargin": IcmsReductionMargin,
        "IcmsStave": IcmsStave,
        "PercImpNBPTState": PercImpNBPTState,
        "PercImpNBPTMunicipal": PercImpNBPTMunicipal,
        "CofinsType": CofinsType,
        "PisType": PisType,
        "ProductIsFatherComposition": ProductIsFatherComposition,
        "QuantityMinimumWholeSale": QuantityMinimumWholeSale,
        "QuantityMinimumWholeSaleByClass": QuantityMinimumWholeSaleByClass,
        "BalanceTare": BalanceTare,
        "FamilyCode": FamilyCode,
        "DepartmentCode": DepartmentCode,
        "SectionCode": SectionCode,
        "GroupCode": GroupCode,
        "SubGroupCode": SubGroupCode,
        "StockQuantity": StockQuantity,
        "AllowFractionate": AllowFractionate,
        "IsBalance": IsBalance,
        "CanBeWeightyInPdv": CanBeWeightyInPdv,
        "QuantityInBalance": QuantityInBalance,
        "AllowQuantityInPdv": AllowQuantityInPdv,
        "GoesForFastTable": GoesForFastTable,
        "IsAlcoholicProduct": IsAlcoholicProduct,
        "SaleRetailPrice": SaleRetailPrice,
        "PercImpNBPTNational": PercImpNBPTNational,
        "SaleRetailPraticed": SaleRetailPraticed,
        "CofinsPercentage": CofinsPercentage,
        "PisPercentage": PisPercentage,
        "CFOP": CFOP,
        "FiscalClassificationNCM": FiscalClassificationNCM,
        "TributarySituationCode": TributarySituationCode,
        "CSTPisCofins": CSTPisCofins,
        "CodeClass": CodeClass,
        "DepartmentName": DepartmentName,
        "SectionName": SectionName,
        "DateOfLastChanged": DateOfLastChanged,
        "GroupName": GroupName,
        "SaleRetailPraticedString": SaleRetailPraticedString,
        "PriceLookupCode": PriceLookupCode,
        "PersonalizedCode": PersonalizedCode,
        "EanCode": EanCode,
        "Name": Name,
        "NameComplete": NameComplete,
        "NameReduced": NameReduced,
        "PackingAbbreviation": PackingAbbreviation,
        "IsPromoCombox": IsPromoCombox,
        "productQuantity": productQuantity,
      };

  static ProductsViewModel fromJson(Map json) => ProductsViewModel(
        IsPromoCombox: json["IsPromoCombox"],
        ProductComplement: json["ProductComplement"],
        ProductsId: json["ProductsId"],
        SaleRetailPraticed: json["SaleRetailPraticed"],
        PriceLookupCode: json["PriceLookupCode"],
        Name: json["Name"],
        PackingAbbreviation: json["PackingAbbreviation"],
        InternalCodeOnERP: json["InternalCodeOnERP"],
        InternalCodeOfProductOnERP: json["InternalCodeOfProductOnERP"],
        EenterpriseId: json["EenterpriseId"],
        PackingQuantity: json["PackingQuantity"],
        OfferRetailPrice: json["OfferRetailPrice"],
        WholeSalePrice: json["WholeSalePrice"],
        WholeOfferPrice: json["WholeOfferPrice"],
        OfferECommercePrice: json["OfferECommercePrice"],
        SaleECommercePrice: json["SaleECommercePrice"],
        LiquidCost: json["LiquidCost"],
        LiquidCostMiddle: json["LiquidCostMiddle"],
        LiquidCostReal: json["LiquidCostReal"],
        RepositionCost: json["RepositionCost"],
        RepositionCostMiddle: json["RepositionCostMiddle"],
        RepositionCostReal: json["RepositionCostReal"],
        IcmsAliquot: json["IcmsAliquot"],
        IcmsIVAMargin: json["IcmsIVAMargin"],
        IcmsReductionMargin: json["IcmsReductionMargin"],
        IcmsStave: json["IcmsStave"],
        PercImpNBPTState: json["PercImpNBPTState"],
        PercImpNBPTMunicipal: json["PercImpNBPTMunicipal"],
        CofinsType: json["CofinsType"],
        PisType: json["PisType"],
        ProductIsFatherComposition: json["ProductIsFatherComposition"],
        QuantityMinimumWholeSale: json["QuantityMinimumWholeSale"],
        QuantityMinimumWholeSaleByClass:
            json["QuantityMinimumWholeSaleByClass"],
        BalanceTare: json["BalanceTare"],
        FamilyCode: json["FamilyCode"],
        DepartmentCode: json["DepartmentCode"],
        SectionCode: json["SectionCode"],
        GroupCode: json["GroupCode"],
        SubGroupCode: json["SubGroupCode"],
        StockQuantity: json["StockQuantity"],
        AllowFractionate: json["AllowFractionate"],
        IsBalance: json["IsBalance"],
        CanBeWeightyInPdv: json["CanBeWeightyInPdv"],
        QuantityInBalance: json["QuantityInBalance"],
        AllowQuantityInPdv: json["AllowQuantityInPdv"],
        GoesForFastTable: json["GoesForFastTable"],
        IsAlcoholicProduct: json["IsAlcoholicProduct"],
        SaleRetailPrice: json["SaleRetailPrice"],
        PercImpNBPTNational: json["PercImpNBPTNational"],
        CofinsPercentage: json["CofinsPercentage"],
        PisPercentage: json["PisPercentage"],
        CFOP: json["CFOP"],
        FiscalClassificationNCM: json["FiscalClassificationNCM"],
        TributarySituationCode: json["TributarySituationCode"],
        CSTPisCofins: json["CSTPisCofins"],
        CodeClass: json["CodeClass"],
        DepartmentName: json["DepartmentName"],
        SectionName: json["SectionName"],
        DateOfLastChanged: json["DateOfLastChanged"],
        GroupName: json["GroupName"],
        SaleRetailPraticedString: json["SaleRetailPraticedString"],
        PersonalizedCode: json["PersonalizedCode"],
        EanCode: json["EanCode"],
        NameComplete: json["NameComplete"],
        NameReduced: json["NameReduced"],
        productQuantity: json["productQuantity"],
      );
}
