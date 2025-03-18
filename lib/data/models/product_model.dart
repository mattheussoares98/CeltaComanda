

import '../../domain/entities/entities.dart';
import 'models.dart';

class ProductModel {
  final int ProductsId;
  final int? InternalCodeOnERP;
  final int? InternalCodeOfProductOnERP;
  final int? EnterpriseId;
  final int? FamilyCode;
  final int? DepartmentCode;
  final int? SectionCode;
  final int? GroupCode;
  final int? SubGroupCode;
  final int? CofinsType;
  final int? PisType;
  final int? ProductIsFatherComposition;
  final double? QuantityMinimumWholeSale;
  final double? QuantityMinimumWholeSaleByClass;
  final double? BalanceTare;
  final double? StockQuantity;
  final double? SaleRetailPrice;
  final double? PercImpNBPTNational;
  final double SaleRetailPraticed;
  final double? CofinsPercentage;
  final double? PisPercentage;
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
  final String? PackingAbbreviation;
  final bool? AllowFractionate;
  final bool? IsBalance;
  final bool? CanBeWeightyInPdv;
  final bool? IsPromoCombox;
  final bool? QuantityInBalance;
  final bool? AllowQuantityInPdv;
  final bool? GoesForFastTable;
  final bool? IsAlcoholicProduct;
  final List<ProductCompositionEntity>? childsComposition;
  final ProductScheduleEntity? Schedule;

  ProductModel({
    required this.ProductsId,
    required this.InternalCodeOnERP,
    required this.InternalCodeOfProductOnERP,
    required this.EnterpriseId,
    required this.FamilyCode,
    required this.DepartmentCode,
    required this.SectionCode,
    required this.GroupCode,
    required this.SubGroupCode,
    required this.CofinsType,
    required this.PisType,
    required this.ProductIsFatherComposition,
    required this.QuantityMinimumWholeSale,
    required this.QuantityMinimumWholeSaleByClass,
    required this.MaximumQuantityForSale,
    required this.BalanceTare,
    required this.StockQuantity,
    required this.SaleRetailPrice,
    required this.PercImpNBPTNational,
    required this.SaleRetailPraticed,
    required this.CofinsPercentage,
    required this.PisPercentage,
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
    required this.PriceLookupCode,
    required this.PersonalizedCode,
    required this.EanCode,
    required this.Name,
    required this.NameComplete,
    required this.NameReduced,
    required this.ProductComplement,
    required this.PackingAbbreviation,
    required this.AllowFractionate,
    required this.IsBalance,
    required this.CanBeWeightyInPdv,
    required this.IsPromoCombox,
    required this.QuantityInBalance,
    required this.AllowQuantityInPdv,
    required this.GoesForFastTable,
    required this.IsAlcoholicProduct,
    required this.childsComposition,
    required this.Schedule,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    if (!json.keys.toSet().containsAll(
      [
        "PackingAbbreviation",
        "SaleRetailPraticed",
        "Name",
        "PriceLookupCode",
        "ProductsId",
      ],
    )) {
      throw Exception();
    }

    return ProductModel(
      SaleRetailPraticed: json["SaleRetailPraticed"],
      MaximumQuantityForSale: json["MaximumQuantityForSale"],
      IsPromoCombox: json["IsPromoCombox"],
      Name: json["Name"],
      ProductsId: json["ProductsId"],
      PackingAbbreviation: json["PackingAbbreviation"],
      PriceLookupCode: json["PriceLookupCode"],
      InternalCodeOnERP: json["InternalCodeOnERP"],
      InternalCodeOfProductOnERP: json["InternalCodeOfProductOnERP"],
      EnterpriseId: json["EenterpriseId"],
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
      QuantityMinimumWholeSaleByClass: json["QuantityMinimumWholeSaleByClass"],
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
      ProductComplement: json["ProductComplement"],
      Schedule: json["Schedule"] == null
          ? null
          : ProductScheduleModel.fromJson(json["Schedule"]).toEntity(),
      childsComposition: json["childsComposition"],
    );
  }

  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      SaleRetailPraticed: entity.SaleRetailPraticed,
      MaximumQuantityForSale: entity.MaximumQuantityForSale,
      IsPromoCombox: entity.IsPromoCombox,
      Name: entity.Name,
      ProductsId: entity.ProductsId,
      PackingAbbreviation: entity.PackingAbbreviation,
      PriceLookupCode: entity.PriceLookupCode,
      InternalCodeOnERP: entity.InternalCodeOnERP,
      InternalCodeOfProductOnERP: entity.InternalCodeOfProductOnERP,
      EnterpriseId: entity.EenterpriseId,
      PackingQuantity: entity.PackingQuantity,
      OfferRetailPrice: entity.OfferRetailPrice,
      WholeSalePrice: entity.WholeSalePrice,
      WholeOfferPrice: entity.WholeOfferPrice,
      OfferECommercePrice: entity.OfferECommercePrice,
      SaleECommercePrice: entity.SaleECommercePrice,
      LiquidCost: entity.LiquidCost,
      LiquidCostMiddle: entity.LiquidCostMiddle,
      LiquidCostReal: entity.LiquidCostReal,
      RepositionCost: entity.RepositionCost,
      RepositionCostMiddle: entity.RepositionCostMiddle,
      RepositionCostReal: entity.RepositionCostReal,
      IcmsAliquot: entity.IcmsAliquot,
      IcmsIVAMargin: entity.IcmsIVAMargin,
      IcmsReductionMargin: entity.IcmsReductionMargin,
      IcmsStave: entity.IcmsStave,
      PercImpNBPTState: entity.PercImpNBPTState,
      PercImpNBPTMunicipal: entity.PercImpNBPTMunicipal,
      CofinsType: entity.CofinsType,
      PisType: entity.PisType,
      ProductIsFatherComposition: entity.ProductIsFatherComposition,
      QuantityMinimumWholeSale: entity.QuantityMinimumWholeSale,
      QuantityMinimumWholeSaleByClass: entity.QuantityMinimumWholeSaleByClass,
      BalanceTare: entity.BalanceTare,
      FamilyCode: entity.FamilyCode,
      DepartmentCode: entity.DepartmentCode,
      SectionCode: entity.SectionCode,
      GroupCode: entity.GroupCode,
      SubGroupCode: entity.SubGroupCode,
      StockQuantity: entity.StockQuantity,
      AllowFractionate: entity.AllowFractionate,
      IsBalance: entity.IsBalance,
      CanBeWeightyInPdv: entity.CanBeWeightyInPdv,
      QuantityInBalance: entity.QuantityInBalance,
      AllowQuantityInPdv: entity.AllowQuantityInPdv,
      GoesForFastTable: entity.GoesForFastTable,
      IsAlcoholicProduct: entity.IsAlcoholicProduct,
      SaleRetailPrice: entity.SaleRetailPrice,
      PercImpNBPTNational: entity.PercImpNBPTNational,
      CofinsPercentage: entity.CofinsPercentage,
      PisPercentage: entity.PisPercentage,
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
      ProductComplement: entity.ProductComplement,
      Schedule: entity.Schedule,
      childsComposition: entity.childsComposition,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ProductsId'] = ProductsId;
    data['MaximumQuantityForSale'] = MaximumQuantityForSale;
    data['InternalCodeOnERP'] = InternalCodeOnERP;
    data['InternalCodeOfProductOnERP'] = InternalCodeOfProductOnERP;
    data['EnterpriseId'] = EnterpriseId;
    data['PriceLookupCode'] = PriceLookupCode;
    data['PersonalizedCode'] = PersonalizedCode;
    data['EanCode'] = EanCode;
    data['Name'] = Name;
    data['NameComplete'] = NameComplete;
    data['NameReduced'] = NameReduced;
    data['PackingAbbreviation'] = PackingAbbreviation;
    data['PackingQuantity'] = PackingQuantity;
    data['SaleRetailPrice'] = SaleRetailPrice;
    data['OfferRetailPrice'] = OfferRetailPrice;
    data['WholeSalePrice'] = WholeSalePrice;
    data['WholeOfferPrice'] = WholeOfferPrice;
    data['OfferECommercePrice'] = OfferECommercePrice;
    data['SaleECommercePrice'] = SaleECommercePrice;
    data['LiquidCost'] = LiquidCost;
    data['LiquidCostMiddle'] = LiquidCostMiddle;
    data['LiquidCostReal'] = LiquidCostReal;
    data['RepositionCost'] = RepositionCost;
    data['RepositionCostMiddle'] = RepositionCostMiddle;
    data['RepositionCostReal'] = RepositionCostReal;
    data['CFOP'] = CFOP;
    data['FiscalClassificationNCM'] = FiscalClassificationNCM;
    data['TributarySituationCode'] = TributarySituationCode;
    data['IcmsAliquot'] = IcmsAliquot;
    data['IcmsIVAMargin'] = IcmsIVAMargin;
    data['IcmsReductionMargin'] = IcmsReductionMargin;
    data['IcmsStave'] = IcmsStave;
    data['PercImpNBPTNational'] = PercImpNBPTNational;
    data['PercImpNBPTState'] = PercImpNBPTState;
    data['PercImpNBPTMunicipal'] = PercImpNBPTMunicipal;
    data['CofinsPercentage'] = CofinsPercentage;
    data['PisPercentage'] = PisPercentage;
    data['CofinsType'] = CofinsType;
    data['PisType'] = PisType;
    data['CSTPisCofins'] = CSTPisCofins;
    data['ProductIsFatherComposition'] = ProductIsFatherComposition;
    data['QuantityMinimumWholeSale'] = QuantityMinimumWholeSale;
    data['QuantityMinimumWholeSaleByClass'] = QuantityMinimumWholeSaleByClass;
    data['AllowFractionate'] = AllowFractionate;
    data['IsBalance'] = IsBalance;
    data['CanBeWeightyInPdv'] = CanBeWeightyInPdv;
    data['QuantityInBalance'] = QuantityInBalance;
    data['AllowQuantityInPdv'] = AllowQuantityInPdv;
    data['GoesForFastTable'] = GoesForFastTable;
    data['IsAlcoholicProduct'] = IsAlcoholicProduct;
    data['BalanceTare'] = BalanceTare;
    data['CodeClass'] = CodeClass;
    data['FamilyCode'] = FamilyCode;
    data['DepartmentCode'] = DepartmentCode;
    data['DepartmentName'] = DepartmentName;
    data['SectionCode'] = SectionCode;
    data['SectionName'] = SectionName;
    data['GroupCode'] = GroupCode;
    data['GroupName'] = GroupName;
    data['SubGroupCode'] = SubGroupCode;
    data['DateOfLastChanged'] = DateOfLastChanged;
    data['StockQuantity'] = StockQuantity;
    data['SaleRetailPraticed'] = SaleRetailPraticed;
    data['SaleRetailPraticedString'] = SaleRetailPraticedString;
    data['ProductComplement'] = ProductComplement;
    data['Schedule'] = Schedule;
    return data;
  }

  ProductEntity toEntity() => ProductEntity(
        IsPromoCombox: IsPromoCombox,
        MaximumQuantityForSale: MaximumQuantityForSale,
        ProductsId: ProductsId,
        InternalCodeOnERP: InternalCodeOnERP,
        InternalCodeOfProductOnERP: InternalCodeOfProductOnERP,
        EenterpriseId: EnterpriseId,
        PriceLookupCode: PriceLookupCode,
        PersonalizedCode: PersonalizedCode,
        EanCode: EanCode,
        Name: Name,
        NameComplete: NameComplete,
        NameReduced: NameReduced,
        PackingAbbreviation: PackingAbbreviation,
        PackingQuantity: PackingQuantity,
        SaleRetailPrice: SaleRetailPrice,
        OfferRetailPrice: OfferRetailPrice,
        WholeSalePrice: WholeSalePrice,
        WholeOfferPrice: WholeOfferPrice,
        OfferECommercePrice: OfferECommercePrice,
        SaleECommercePrice: SaleECommercePrice,
        LiquidCost: LiquidCost,
        LiquidCostMiddle: LiquidCostMiddle,
        LiquidCostReal: LiquidCostReal,
        RepositionCost: RepositionCost,
        RepositionCostMiddle: RepositionCostMiddle,
        RepositionCostReal: RepositionCostReal,
        CFOP: CFOP,
        FiscalClassificationNCM: FiscalClassificationNCM,
        TributarySituationCode: TributarySituationCode,
        IcmsAliquot: IcmsAliquot,
        IcmsIVAMargin: IcmsIVAMargin,
        IcmsReductionMargin: IcmsReductionMargin,
        IcmsStave: IcmsStave,
        PercImpNBPTNational: PercImpNBPTNational,
        PercImpNBPTState: PercImpNBPTState,
        PercImpNBPTMunicipal: PercImpNBPTMunicipal,
        CofinsPercentage: CofinsPercentage,
        PisPercentage: PisPercentage,
        CofinsType: CofinsType,
        PisType: PisType,
        CSTPisCofins: CSTPisCofins,
        ProductIsFatherComposition: ProductIsFatherComposition,
        QuantityMinimumWholeSale: QuantityMinimumWholeSale,
        QuantityMinimumWholeSaleByClass: QuantityMinimumWholeSaleByClass,
        AllowFractionate: AllowFractionate,
        IsBalance: IsBalance,
        CanBeWeightyInPdv: CanBeWeightyInPdv,
        QuantityInBalance: QuantityInBalance,
        AllowQuantityInPdv: AllowQuantityInPdv,
        GoesForFastTable: GoesForFastTable,
        IsAlcoholicProduct: IsAlcoholicProduct,
        BalanceTare: BalanceTare,
        CodeClass: CodeClass,
        FamilyCode: FamilyCode,
        DepartmentCode: DepartmentCode,
        DepartmentName: DepartmentName,
        SectionCode: SectionCode,
        SectionName: SectionName,
        GroupCode: GroupCode,
        GroupName: GroupName,
        SubGroupCode: SubGroupCode,
        DateOfLastChanged: DateOfLastChanged,
        StockQuantity: StockQuantity,
        SaleRetailPraticed: SaleRetailPraticed,
        SaleRetailPraticedString: SaleRetailPraticedString,
        ProductComplement: ProductComplement,
        Schedule: Schedule,
        childsComposition: childsComposition,
      );
}
