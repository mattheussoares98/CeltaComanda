class ProductModel {
  int? productsId;
  int? internalCodeOnERP;
  int? internalCodeOfProductOnERP;
  int? enterpriseId;
  String? priceLookupCode;
  String? personalizedCode;
  String? eanCode;
  String? name;
  String? nameComplete;
  String? nameReduced;
  String? packingAbbreviation;
  int? packingQuantity;
  double? saleRetailPrice;
  int? offerRetailPrice;
  int? wholeSalePrice;
  int? wholeOfferPrice;
  int? offerECommercePrice;
  int? saleECommercePrice;
  int? liquidCost;
  int? liquidCostMiddle;
  int? liquidCostReal;
  int? repositionCost;
  int? repositionCostMiddle;
  int? repositionCostReal;
  String? cFOP;
  String? fiscalClassificationNCM;
  String? tributarySituationCode;
  int? icmsAliquot;
  int? icmsIVAMargin;
  int? icmsReductionMargin;
  int? icmsStave;
  double? percImpNBPTNational;
  int? percImpNBPTState;
  int? percImpNBPTMunicipal;
  double? cofinsPercentage;
  double? pisPercentage;
  int? cofinsType;
  int? pisType;
  String? cSTPisCofins;
  int? productIsFatherComposition;
  int? quantityMinimumWholeSale;
  int? quantityMinimumWholeSaleByClass;
  bool? allowFractionate;
  bool? isBalance;
  bool? canBeWeightyInPdv;
  bool? quantityInBalance;
  bool? allowQuantityInPdv;
  bool? goesForFastTable;
  bool? isAlcoholicProduct;
  int? balanceTare;
  String? codeClass;
  int? familyCode;
  int? departmentCode;
  String? departmentName;
  int? sectionCode;
  String? sectionName;
  int? groupCode;
  String? groupName;
  int? subGroupCode;
  String? dateOfLastChanged;
  int? stockQuantity;
  double? saleRetailPraticed;
  String? saleRetailPraticedString;

  ProductModel({
    this.productsId,
    this.internalCodeOnERP,
    this.internalCodeOfProductOnERP,
    this.enterpriseId,
    this.priceLookupCode,
    this.personalizedCode,
    this.eanCode,
    this.name,
    this.nameComplete,
    this.nameReduced,
    this.packingAbbreviation,
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
    this.saleRetailPraticed,
    this.saleRetailPraticedString,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    productsId = json['ProductsId'];
    internalCodeOnERP = json['InternalCodeOnERP'];
    internalCodeOfProductOnERP = json['InternalCodeOfProductOnERP'];
    enterpriseId = json['EnterpriseId'];
    priceLookupCode = json['PriceLookupCode'];
    personalizedCode = json['PersonalizedCode'];
    eanCode = json['EanCode'];
    name = json['Name'];
    nameComplete = json['NameComplete'];
    nameReduced = json['NameReduced'];
    packingAbbreviation = json['PackingAbbreviation'];
    packingQuantity = json['PackingQuantity'];
    saleRetailPrice = json['SaleRetailPrice'];
    offerRetailPrice = json['OfferRetailPrice'];
    wholeSalePrice = json['WholeSalePrice'];
    wholeOfferPrice = json['WholeOfferPrice'];
    offerECommercePrice = json['OfferECommercePrice'];
    saleECommercePrice = json['SaleECommercePrice'];
    liquidCost = json['LiquidCost'];
    liquidCostMiddle = json['LiquidCostMiddle'];
    liquidCostReal = json['LiquidCostReal'];
    repositionCost = json['RepositionCost'];
    repositionCostMiddle = json['RepositionCostMiddle'];
    repositionCostReal = json['RepositionCostReal'];
    cFOP = json['CFOP'];
    fiscalClassificationNCM = json['FiscalClassificationNCM'];
    tributarySituationCode = json['TributarySituationCode'];
    icmsAliquot = json['IcmsAliquot'];
    icmsIVAMargin = json['IcmsIVAMargin'];
    icmsReductionMargin = json['IcmsReductionMargin'];
    icmsStave = json['IcmsStave'];
    percImpNBPTNational = json['PercImpNBPTNational'];
    percImpNBPTState = json['PercImpNBPTState'];
    percImpNBPTMunicipal = json['PercImpNBPTMunicipal'];
    cofinsPercentage = json['CofinsPercentage'];
    pisPercentage = json['PisPercentage'];
    cofinsType = json['CofinsType'];
    pisType = json['PisType'];
    cSTPisCofins = json['CSTPisCofins'];
    productIsFatherComposition = json['ProductIsFatherComposition'];
    quantityMinimumWholeSale = json['QuantityMinimumWholeSale'];
    quantityMinimumWholeSaleByClass = json['QuantityMinimumWholeSaleByClass'];
    allowFractionate = json['AllowFractionate'];
    isBalance = json['IsBalance'];
    canBeWeightyInPdv = json['CanBeWeightyInPdv'];
    quantityInBalance = json['QuantityInBalance'];
    allowQuantityInPdv = json['AllowQuantityInPdv'];
    goesForFastTable = json['GoesForFastTable'];
    isAlcoholicProduct = json['IsAlcoholicProduct'];
    balanceTare = json['BalanceTare'];
    codeClass = json['CodeClass'];
    familyCode = json['FamilyCode'];
    departmentCode = json['DepartmentCode'];
    departmentName = json['DepartmentName'];
    sectionCode = json['SectionCode'];
    sectionName = json['SectionName'];
    groupCode = json['GroupCode'];
    groupName = json['GroupName'];
    subGroupCode = json['SubGroupCode'];
    dateOfLastChanged = json['DateOfLastChanged'];
    stockQuantity = json['StockQuantity'];
    saleRetailPraticed = json['SaleRetailPraticed'];
    saleRetailPraticedString = json['SaleRetailPraticedString'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ProductsId'] = productsId;
    data['InternalCodeOnERP'] = internalCodeOnERP;
    data['InternalCodeOfProductOnERP'] = internalCodeOfProductOnERP;
    data['EnterpriseId'] = enterpriseId;
    data['PriceLookupCode'] = priceLookupCode;
    data['PersonalizedCode'] = personalizedCode;
    data['EanCode'] = eanCode;
    data['Name'] = name;
    data['NameComplete'] = nameComplete;
    data['NameReduced'] = nameReduced;
    data['PackingAbbreviation'] = packingAbbreviation;
    data['PackingQuantity'] = packingQuantity;
    data['SaleRetailPrice'] = saleRetailPrice;
    data['OfferRetailPrice'] = offerRetailPrice;
    data['WholeSalePrice'] = wholeSalePrice;
    data['WholeOfferPrice'] = wholeOfferPrice;
    data['OfferECommercePrice'] = offerECommercePrice;
    data['SaleECommercePrice'] = saleECommercePrice;
    data['LiquidCost'] = liquidCost;
    data['LiquidCostMiddle'] = liquidCostMiddle;
    data['LiquidCostReal'] = liquidCostReal;
    data['RepositionCost'] = repositionCost;
    data['RepositionCostMiddle'] = repositionCostMiddle;
    data['RepositionCostReal'] = repositionCostReal;
    data['CFOP'] = cFOP;
    data['FiscalClassificationNCM'] = fiscalClassificationNCM;
    data['TributarySituationCode'] = tributarySituationCode;
    data['IcmsAliquot'] = icmsAliquot;
    data['IcmsIVAMargin'] = icmsIVAMargin;
    data['IcmsReductionMargin'] = icmsReductionMargin;
    data['IcmsStave'] = icmsStave;
    data['PercImpNBPTNational'] = percImpNBPTNational;
    data['PercImpNBPTState'] = percImpNBPTState;
    data['PercImpNBPTMunicipal'] = percImpNBPTMunicipal;
    data['CofinsPercentage'] = cofinsPercentage;
    data['PisPercentage'] = pisPercentage;
    data['CofinsType'] = cofinsType;
    data['PisType'] = pisType;
    data['CSTPisCofins'] = cSTPisCofins;
    data['ProductIsFatherComposition'] = productIsFatherComposition;
    data['QuantityMinimumWholeSale'] = quantityMinimumWholeSale;
    data['QuantityMinimumWholeSaleByClass'] = quantityMinimumWholeSaleByClass;
    data['AllowFractionate'] = allowFractionate;
    data['IsBalance'] = isBalance;
    data['CanBeWeightyInPdv'] = canBeWeightyInPdv;
    data['QuantityInBalance'] = quantityInBalance;
    data['AllowQuantityInPdv'] = allowQuantityInPdv;
    data['GoesForFastTable'] = goesForFastTable;
    data['IsAlcoholicProduct'] = isAlcoholicProduct;
    data['BalanceTare'] = balanceTare;
    data['CodeClass'] = codeClass;
    data['FamilyCode'] = familyCode;
    data['DepartmentCode'] = departmentCode;
    data['DepartmentName'] = departmentName;
    data['SectionCode'] = sectionCode;
    data['SectionName'] = sectionName;
    data['GroupCode'] = groupCode;
    data['GroupName'] = groupName;
    data['SubGroupCode'] = subGroupCode;
    data['DateOfLastChanged'] = dateOfLastChanged;
    data['StockQuantity'] = stockQuantity;
    data['SaleRetailPraticed'] = saleRetailPraticed;
    data['SaleRetailPraticedString'] = saleRetailPraticedString;
    return data;
  }

  ProductModel toEntity() => ProductModel(
        productsId: productsId,
        internalCodeOnERP: internalCodeOnERP,
        internalCodeOfProductOnERP: internalCodeOfProductOnERP,
        enterpriseId: enterpriseId,
        priceLookupCode: priceLookupCode,
        personalizedCode: personalizedCode,
        eanCode: eanCode,
        name: name,
        nameComplete: nameComplete,
        nameReduced: nameReduced,
        packingAbbreviation: packingAbbreviation,
        packingQuantity: packingQuantity,
        saleRetailPrice: saleRetailPrice,
        offerRetailPrice: offerRetailPrice,
        wholeSalePrice: wholeSalePrice,
        wholeOfferPrice: wholeOfferPrice,
        offerECommercePrice: offerECommercePrice,
        saleECommercePrice: saleECommercePrice,
        liquidCost: liquidCost,
        liquidCostMiddle: liquidCostMiddle,
        liquidCostReal: liquidCostReal,
        repositionCost: repositionCost,
        repositionCostMiddle: repositionCostMiddle,
        repositionCostReal: repositionCostReal,
        cFOP: cFOP,
        fiscalClassificationNCM: fiscalClassificationNCM,
        tributarySituationCode: tributarySituationCode,
        icmsAliquot: icmsAliquot,
        icmsIVAMargin: icmsIVAMargin,
        icmsReductionMargin: icmsReductionMargin,
        icmsStave: icmsStave,
        percImpNBPTNational: percImpNBPTNational,
        percImpNBPTState: percImpNBPTState,
        percImpNBPTMunicipal: percImpNBPTMunicipal,
        cofinsPercentage: cofinsPercentage,
        pisPercentage: pisPercentage,
        cofinsType: cofinsType,
        pisType: pisType,
        cSTPisCofins: cSTPisCofins,
        productIsFatherComposition: productIsFatherComposition,
        quantityMinimumWholeSale: quantityMinimumWholeSale,
        quantityMinimumWholeSaleByClass: quantityMinimumWholeSaleByClass,
        allowFractionate: allowFractionate,
        isBalance: isBalance,
        canBeWeightyInPdv: canBeWeightyInPdv,
        quantityInBalance: quantityInBalance,
        allowQuantityInPdv: allowQuantityInPdv,
        goesForFastTable: goesForFastTable,
        isAlcoholicProduct: isAlcoholicProduct,
        balanceTare: balanceTare,
        codeClass: codeClass,
        familyCode: familyCode,
        departmentCode: departmentCode,
        departmentName: departmentName,
        sectionCode: sectionCode,
        sectionName: sectionName,
        groupCode: groupCode,
        groupName: groupName,
        subGroupCode: subGroupCode,
        dateOfLastChanged: dateOfLastChanged,
        stockQuantity: stockQuantity,
        saleRetailPraticed: saleRetailPraticed,
        saleRetailPraticedString: saleRetailPraticedString,
      );
}
