import 'package:clean_celta_mobile/data/models/models.dart';
import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import 'package:faker/faker.dart';

class EntityFactory {
  static EnterpriseEntity makeEnterpriseData() {
    return EnterpriseEntity(
      url: faker.internet.httpUrl().toLowerCase().removeWhiteSpaces(),
      urlCCS: faker.internet.httpUrl(),
      enterpriseId: faker.randomGenerator.integer(3),
      enterpriseName: faker.company.name().toLowerCase().removeWhiteSpaces(),
      concentradorUrl:
          faker.internet.httpUrl().toLowerCase().removeWhiteSpaces(),
      persistApp: faker.randomGenerator.boolean(),
      useCovenant: faker.randomGenerator.boolean(),
      enterpriseConcentradorParametersEntity:
          makeEnterpriseConcentradorParametersEntity(),
      updateMenuCount: faker.randomGenerator.integer(100),
      updateEnterpriseCount: faker.randomGenerator.integer(100),
      serviceChargePercentageOrValue: faker.randomGenerator.decimal(),
      serviceChargeType: faker.randomGenerator.integer(2, min: 1),
    );
  }

  static List<ProductEntity> makeProductsEntitys(
      {bool? isPromoCombox, bool? generateChilds}) {
    return [
      ProductEntity(
        MaximumQuantityForSale: faker.randomGenerator.decimal(),
        ProductComplement: faker.randomGenerator.string(100),
        IsPromoCombox: isPromoCombox ?? faker.randomGenerator.boolean(),
        ProductsId: faker.randomGenerator.integer(100),
        InternalCodeOnERP: faker.randomGenerator.integer(100),
        InternalCodeOfProductOnERP: faker.randomGenerator.integer(100),
        EenterpriseId: faker.randomGenerator.integer(100),
        PackingQuantity: faker.randomGenerator.decimal(min: 5),
        OfferRetailPrice: faker.randomGenerator.decimal(min: 5),
        WholeSalePrice: faker.randomGenerator.decimal(min: 5),
        WholeOfferPrice: faker.randomGenerator.decimal(min: 5),
        OfferECommercePrice: faker.randomGenerator.decimal(min: 5),
        SaleECommercePrice: faker.randomGenerator.decimal(min: 5),
        LiquidCost: faker.randomGenerator.decimal(min: 5),
        LiquidCostMiddle: faker.randomGenerator.decimal(min: 5),
        LiquidCostReal: faker.randomGenerator.decimal(min: 5),
        RepositionCost: faker.randomGenerator.decimal(min: 5),
        RepositionCostMiddle: faker.randomGenerator.decimal(min: 5),
        RepositionCostReal: faker.randomGenerator.decimal(min: 5),
        IcmsAliquot: faker.randomGenerator.decimal(min: 5),
        IcmsIVAMargin: faker.randomGenerator.decimal(min: 5),
        IcmsReductionMargin: faker.randomGenerator.decimal(min: 5),
        IcmsStave: faker.randomGenerator.decimal(min: 5),
        PercImpNBPTState: faker.randomGenerator.decimal(min: 5),
        PercImpNBPTMunicipal: faker.randomGenerator.decimal(min: 5),
        CofinsType: faker.randomGenerator.integer(100),
        PisType: faker.randomGenerator.integer(100),
        ProductIsFatherComposition: faker.randomGenerator.integer(100),
        QuantityMinimumWholeSale: faker.randomGenerator.decimal(min: 5),
        QuantityMinimumWholeSaleByClass: faker.randomGenerator.decimal(min: 5),
        BalanceTare: faker.randomGenerator.decimal(min: 5),
        FamilyCode: faker.randomGenerator.integer(100),
        DepartmentCode: faker.randomGenerator.integer(100),
        SectionCode: faker.randomGenerator.integer(100),
        GroupCode: faker.randomGenerator.integer(100),
        SubGroupCode: faker.randomGenerator.integer(100),
        StockQuantity: faker.randomGenerator.decimal(min: 5),
        AllowFractionate: faker.randomGenerator.boolean(),
        IsBalance: faker.randomGenerator.boolean(),
        CanBeWeightyInPdv: faker.randomGenerator.boolean(),
        QuantityInBalance: faker.randomGenerator.boolean(),
        AllowQuantityInPdv: faker.randomGenerator.boolean(),
        GoesForFastTable: faker.randomGenerator.boolean(),
        IsAlcoholicProduct: faker.randomGenerator.boolean(),
        SaleRetailPrice: faker.randomGenerator.decimal(min: 5),
        PercImpNBPTNational: faker.randomGenerator.decimal(min: 5),
        SaleRetailPraticed: faker.randomGenerator.decimal(min: 5),
        CofinsPercentage: faker.randomGenerator.decimal(min: 5),
        PisPercentage: faker.randomGenerator.decimal(min: 5),
        CFOP: faker.randomGenerator.string(100),
        FiscalClassificationNCM: faker.randomGenerator.string(100),
        TributarySituationCode: faker.randomGenerator.string(100),
        CSTPisCofins: faker.randomGenerator.string(100),
        CodeClass: faker.randomGenerator.string(100),
        DepartmentName: faker.randomGenerator.string(100),
        SectionName: faker.randomGenerator.string(100),
        DateOfLastChanged: faker.randomGenerator.string(100),
        GroupName: faker.randomGenerator.string(100),
        SaleRetailPraticedString: faker.randomGenerator.string(100),
        PriceLookupCode: faker.randomGenerator.string(100),
        PersonalizedCode: faker.randomGenerator.string(100),
        EanCode: faker.randomGenerator.string(100),
        Name: faker.randomGenerator.string(100),
        NameComplete: faker.randomGenerator.string(100),
        NameReduced: faker.randomGenerator.string(100),
        PackingAbbreviation: faker.randomGenerator.string(100),
        childsComposition: generateChilds == true
            ? makeProductsCompositionsEntity(isOptionalItem: true)
            : null,
      ),
      ProductEntity(
        MaximumQuantityForSale: faker.randomGenerator.decimal(),
        ProductComplement: faker.randomGenerator.string(100),
        IsPromoCombox: isPromoCombox ?? faker.randomGenerator.boolean(),
        ProductsId: faker.randomGenerator.integer(100),
        InternalCodeOnERP: faker.randomGenerator.integer(100),
        InternalCodeOfProductOnERP: faker.randomGenerator.integer(100),
        EenterpriseId: faker.randomGenerator.integer(100),
        PackingQuantity: faker.randomGenerator.decimal(min: 5),
        OfferRetailPrice: faker.randomGenerator.decimal(min: 5),
        WholeSalePrice: faker.randomGenerator.decimal(min: 5),
        WholeOfferPrice: faker.randomGenerator.decimal(min: 5),
        OfferECommercePrice: faker.randomGenerator.decimal(min: 5),
        SaleECommercePrice: faker.randomGenerator.decimal(min: 5),
        LiquidCost: faker.randomGenerator.decimal(min: 5),
        LiquidCostMiddle: faker.randomGenerator.decimal(min: 5),
        LiquidCostReal: faker.randomGenerator.decimal(min: 5),
        RepositionCost: faker.randomGenerator.decimal(min: 5),
        RepositionCostMiddle: faker.randomGenerator.decimal(min: 5),
        RepositionCostReal: faker.randomGenerator.decimal(min: 5),
        IcmsAliquot: faker.randomGenerator.decimal(min: 5),
        IcmsIVAMargin: faker.randomGenerator.decimal(min: 5),
        IcmsReductionMargin: faker.randomGenerator.decimal(min: 5),
        IcmsStave: faker.randomGenerator.decimal(min: 5),
        PercImpNBPTState: faker.randomGenerator.decimal(min: 5),
        PercImpNBPTMunicipal: faker.randomGenerator.decimal(min: 5),
        CofinsType: faker.randomGenerator.integer(100),
        PisType: faker.randomGenerator.integer(100),
        ProductIsFatherComposition: faker.randomGenerator.integer(100),
        QuantityMinimumWholeSale: faker.randomGenerator.decimal(min: 5),
        QuantityMinimumWholeSaleByClass: faker.randomGenerator.decimal(min: 5),
        BalanceTare: faker.randomGenerator.decimal(min: 5),
        FamilyCode: faker.randomGenerator.integer(100),
        DepartmentCode: faker.randomGenerator.integer(100),
        SectionCode: faker.randomGenerator.integer(100),
        GroupCode: faker.randomGenerator.integer(100),
        SubGroupCode: faker.randomGenerator.integer(100),
        StockQuantity: faker.randomGenerator.decimal(min: 5),
        AllowFractionate: faker.randomGenerator.boolean(),
        IsBalance: faker.randomGenerator.boolean(),
        CanBeWeightyInPdv: faker.randomGenerator.boolean(),
        QuantityInBalance: faker.randomGenerator.boolean(),
        AllowQuantityInPdv: faker.randomGenerator.boolean(),
        GoesForFastTable: faker.randomGenerator.boolean(),
        IsAlcoholicProduct: faker.randomGenerator.boolean(),
        SaleRetailPrice: faker.randomGenerator.decimal(min: 5),
        PercImpNBPTNational: faker.randomGenerator.decimal(min: 5),
        SaleRetailPraticed: faker.randomGenerator.decimal(min: 5),
        CofinsPercentage: faker.randomGenerator.decimal(min: 5),
        PisPercentage: faker.randomGenerator.decimal(min: 5),
        CFOP: faker.randomGenerator.string(100),
        FiscalClassificationNCM: faker.randomGenerator.string(100),
        TributarySituationCode: faker.randomGenerator.string(100),
        CSTPisCofins: faker.randomGenerator.string(100),
        CodeClass: faker.randomGenerator.string(100),
        DepartmentName: faker.randomGenerator.string(100),
        SectionName: faker.randomGenerator.string(100),
        DateOfLastChanged: faker.randomGenerator.string(100),
        GroupName: faker.randomGenerator.string(100),
        SaleRetailPraticedString: faker.randomGenerator.string(100),
        PriceLookupCode: faker.randomGenerator.string(100),
        PersonalizedCode: faker.randomGenerator.string(100),
        EanCode: faker.randomGenerator.string(100),
        Name: faker.randomGenerator.string(100),
        NameComplete: faker.randomGenerator.string(100),
        NameReduced: faker.randomGenerator.string(100),
        PackingAbbreviation: faker.randomGenerator.string(100),
        childsComposition: generateChilds == true
            ? makeProductsCompositionsEntity(isOptionalItem: true)
            : null,
      ),
    ];
  }

  static List<ExpansibleGroupEntity> makeExpansibleGroupsEntity() {
    return [
      ExpansibleGroupEntity(
        Name: faker.randomGenerator.string(30),
        ExpansibleGroupId: faker.randomGenerator.integer(999),
        ExpansibleGroupType: faker.randomGenerator.integer(999),
        OrderClassification: faker.randomGenerator.integer(999),
      ),
      ExpansibleGroupEntity(
        Name: faker.randomGenerator.string(30),
        ExpansibleGroupId: faker.randomGenerator.integer(999),
        ExpansibleGroupType: faker.randomGenerator.integer(999),
        OrderClassification: faker.randomGenerator.integer(999),
      ),
    ];
  }

  static SaleRequestTempViewModel makeSaleRequestTempViewModel(
      List<ProductModel> products) {
    return SaleRequestTempViewModel(
      Comments: null,
      SellerCode: faker.randomGenerator.integer(100).toString(),
      Peoples: faker.randomGenerator.integer(100).toString(),
      SaleRequestTempId: faker.randomGenerator.integer(3).toString(),
      Products: products
          .map((e) => SaleRequestTempProductsViewModel(
                Product: makeProductsViewModel(),
                IsPrinted: faker.randomGenerator.boolean().toString(),
                SaleRequestProductTempId:
                    faker.randomGenerator.integer(10).toString(),
                SaleRequestTempId: faker.randomGenerator.integer(10).toString(),
                ProductInternalCodeOnErp:
                    faker.randomGenerator.integer(10).toString(),
                Comments: faker.randomGenerator.string(50),
                TotalLiquid: faker.randomGenerator.decimal().toString(),
                Quantity: faker.randomGenerator.decimal().toString(),
                Value: faker.randomGenerator.decimal().toString(),
                ProductPriceLookUpCode:
                    faker.randomGenerator.integer(10).toString(),
                SaleRequestProductIdOfFather: null,
                ProductIsFatherComposition: null,
              ))
          .toList(),
      PersonalizedCode: faker.randomGenerator.string(10),
      EnterpriseId: faker.randomGenerator.integer(3).toString(),
      CustomerCode: faker.randomGenerator.integer(100).toString(),
      CovenantCode: faker.randomGenerator.integer(100).toString(),
      DeliveryControl: faker.randomGenerator.integer(3).toString(),
      TotalLiquid: faker.randomGenerator.decimal(min: 0.01).toString(),
      IncrementValue: faker.randomGenerator.decimal(min: 0.01).toString(),
      IncrementType: faker.randomGenerator.integer(2, min: 1).toString(),
    );
  }

  static ProductsViewModel makeProductsViewModel({
    bool? insertChildsComposition,
    bool? isOptionalChilds,
    int? maximumProductQuantity,
    double? productQuantity,
    String? subgroupName,
    bool? insertOfferPrice = true,
  }) {
    return ProductsViewModel(
      subgroupName: subgroupName,
      suggestions: null,
      MaximumQuantityForSale: maximumProductQuantity != null
          ? maximumProductQuantity.toString()
          : faker.randomGenerator.decimal().toString(),
      ProductComplement: faker.randomGenerator.string(10),
      IsPromoCombox: faker.randomGenerator.boolean().toString(),
      SaleRetailPraticed: faker.randomGenerator.decimal(min: 0.01).toString(),
      PackingAbbreviation: faker.randomGenerator.string(10),
      Name: faker.food.random.string(10),
      EanCode: faker.randomGenerator.integer(20).toString(),
      PriceLookupCode: faker.randomGenerator.string(10),
      ProductsId: faker.randomGenerator.integer(10).toString(),
      InternalCodeOnERP: faker.randomGenerator.integer(10).toString(),
      InternalCodeOfProductOnERP: faker.randomGenerator.integer(10).toString(),
      EenterpriseId: faker.randomGenerator.integer(10).toString(),
      PackingQuantity: faker.randomGenerator.decimal().toString(),
      OfferRetailPrice: insertOfferPrice == true
          ? faker.randomGenerator.decimal().toString()
          : null,
      WholeSalePrice: faker.randomGenerator.decimal().toString(),
      WholeOfferPrice: faker.randomGenerator.decimal().toString(),
      OfferECommercePrice: faker.randomGenerator.decimal().toString(),
      SaleECommercePrice: faker.randomGenerator.decimal().toString(),
      LiquidCost: faker.randomGenerator.decimal().toString(),
      LiquidCostMiddle: faker.randomGenerator.decimal().toString(),
      LiquidCostReal: faker.randomGenerator.decimal().toString(),
      RepositionCost: faker.randomGenerator.decimal().toString(),
      RepositionCostMiddle: faker.randomGenerator.decimal().toString(),
      RepositionCostReal: faker.randomGenerator.decimal().toString(),
      IcmsAliquot: faker.randomGenerator.decimal().toString(),
      IcmsIVAMargin: faker.randomGenerator.decimal().toString(),
      IcmsReductionMargin: faker.randomGenerator.decimal().toString(),
      IcmsStave: faker.randomGenerator.decimal().toString(),
      PercImpNBPTState: faker.randomGenerator.decimal().toString(),
      PercImpNBPTMunicipal: faker.randomGenerator.decimal().toString(),
      CofinsType: faker.randomGenerator.integer(100).toString(),
      PisType: faker.randomGenerator.integer(100).toString(),
      ProductIsFatherComposition: faker.randomGenerator.integer(100).toString(),
      QuantityMinimumWholeSale: faker.randomGenerator.decimal().toString(),
      QuantityMinimumWholeSaleByClass:
          faker.randomGenerator.decimal().toString(),
      BalanceTare: faker.randomGenerator.decimal().toString(),
      FamilyCode: faker.randomGenerator.integer(100).toString(),
      DepartmentCode: faker.randomGenerator.integer(100).toString(),
      SectionCode: faker.randomGenerator.integer(100).toString(),
      GroupCode: faker.randomGenerator.integer(100).toString(),
      SubGroupCode: faker.randomGenerator.integer(100).toString(),
      StockQuantity: faker.randomGenerator.decimal().toString(),
      AllowFractionate: faker.randomGenerator.boolean().toString(),
      IsBalance: faker.randomGenerator.boolean().toString(),
      CanBeWeightyInPdv: faker.randomGenerator.boolean().toString(),
      QuantityInBalance: faker.randomGenerator.boolean().toString(),
      AllowQuantityInPdv: faker.randomGenerator.boolean().toString(),
      GoesForFastTable: faker.randomGenerator.boolean().toString(),
      IsAlcoholicProduct: faker.randomGenerator.boolean().toString(),
      SaleRetailPrice: faker.randomGenerator.string(10),
      PercImpNBPTNational: faker.randomGenerator.string(10),
      CofinsPercentage: faker.randomGenerator.string(10),
      PisPercentage: faker.randomGenerator.string(10),
      CFOP: faker.randomGenerator.string(10),
      FiscalClassificationNCM: faker.randomGenerator.string(10),
      TributarySituationCode: faker.randomGenerator.string(10),
      CSTPisCofins: faker.randomGenerator.string(10),
      CodeClass: faker.randomGenerator.string(10),
      DepartmentName: faker.randomGenerator.string(10),
      SectionName: faker.randomGenerator.string(10),
      DateOfLastChanged: faker.randomGenerator.string(10),
      GroupName: faker.randomGenerator.string(10),
      SaleRetailPraticedString: faker.randomGenerator.string(10),
      PersonalizedCode: faker.randomGenerator.string(10),
      NameComplete: faker.randomGenerator.string(10),
      NameReduced: faker.randomGenerator.string(10),
      productQuantity: productQuantity ?? 1.0,
      childsComposition: insertChildsComposition == true
          ? [
              makeProductCompositionViewModel(
                quantity: faker.randomGenerator.decimal(),
                salePrice: faker.randomGenerator.decimal(),
                offerPrice: faker.randomGenerator.decimal(),
                fatherIncrement: faker.randomGenerator.decimal(),
                childIncrement: faker.randomGenerator.decimal(),
                isOptionalItem:
                    isOptionalChilds ?? faker.randomGenerator.boolean(),
                indexOfSelectedChild: null,
                insertChilds: false,
              )
            ]
          : null,
    );
  }

  static List<ProductModel> makeProductModel() {
    return [
      ProductModel(
        MaximumQuantityForSale: faker.randomGenerator.decimal(),
        ProductComplement: faker.randomGenerator.string(10),
        ProductsId: faker.randomGenerator.integer(20),
        InternalCodeOnERP: faker.randomGenerator.integer(20),
        InternalCodeOfProductOnERP: faker.randomGenerator.integer(20),
        EnterpriseId: faker.randomGenerator.integer(20),
        FamilyCode: faker.randomGenerator.integer(20),
        DepartmentCode: faker.randomGenerator.integer(20),
        SectionCode: faker.randomGenerator.integer(20),
        GroupCode: faker.randomGenerator.integer(20),
        SubGroupCode: faker.randomGenerator.integer(20),
        CofinsType: faker.randomGenerator.integer(20),
        PisType: faker.randomGenerator.integer(20),
        ProductIsFatherComposition: faker.randomGenerator.integer(20),
        QuantityMinimumWholeSale: faker.randomGenerator.decimal(),
        QuantityMinimumWholeSaleByClass: faker.randomGenerator.decimal(),
        BalanceTare: faker.randomGenerator.decimal(),
        StockQuantity: faker.randomGenerator.decimal(),
        SaleRetailPrice: faker.randomGenerator.decimal(),
        PercImpNBPTNational: faker.randomGenerator.decimal(),
        SaleRetailPraticed: faker.randomGenerator.decimal(),
        CofinsPercentage: faker.randomGenerator.decimal(),
        PisPercentage: faker.randomGenerator.decimal(),
        PackingQuantity: faker.randomGenerator.decimal(),
        OfferRetailPrice: faker.randomGenerator.decimal(),
        WholeSalePrice: faker.randomGenerator.decimal(),
        WholeOfferPrice: faker.randomGenerator.decimal(),
        OfferECommercePrice: faker.randomGenerator.decimal(),
        SaleECommercePrice: faker.randomGenerator.decimal(),
        LiquidCost: faker.randomGenerator.decimal(),
        LiquidCostMiddle: faker.randomGenerator.decimal(),
        LiquidCostReal: faker.randomGenerator.decimal(),
        RepositionCost: faker.randomGenerator.decimal(),
        RepositionCostMiddle: faker.randomGenerator.decimal(),
        RepositionCostReal: faker.randomGenerator.decimal(),
        IcmsAliquot: faker.randomGenerator.decimal(),
        IcmsIVAMargin: faker.randomGenerator.decimal(),
        IcmsReductionMargin: faker.randomGenerator.decimal(),
        IcmsStave: faker.randomGenerator.decimal(),
        PercImpNBPTState: faker.randomGenerator.decimal(),
        PercImpNBPTMunicipal: faker.randomGenerator.decimal(),
        CFOP: faker.randomGenerator.string(10),
        FiscalClassificationNCM: faker.randomGenerator.string(10),
        TributarySituationCode: faker.randomGenerator.string(10),
        CSTPisCofins: faker.randomGenerator.string(10),
        CodeClass: faker.randomGenerator.string(10),
        DepartmentName: faker.randomGenerator.string(10),
        SectionName: faker.randomGenerator.string(10),
        DateOfLastChanged: faker.randomGenerator.string(10),
        GroupName: faker.randomGenerator.string(10),
        SaleRetailPraticedString: faker.randomGenerator.string(10),
        PriceLookupCode: faker.randomGenerator.string(10),
        PersonalizedCode: faker.randomGenerator.string(10),
        EanCode: faker.randomGenerator.string(10),
        Name: faker.randomGenerator.string(10),
        NameComplete: faker.randomGenerator.string(10),
        NameReduced: faker.randomGenerator.string(10),
        PackingAbbreviation: faker.randomGenerator.string(10),
        AllowFractionate: faker.randomGenerator.boolean(),
        IsBalance: faker.randomGenerator.boolean(),
        CanBeWeightyInPdv: faker.randomGenerator.boolean(),
        IsPromoCombox: faker.randomGenerator.boolean(),
        QuantityInBalance: faker.randomGenerator.boolean(),
        AllowQuantityInPdv: faker.randomGenerator.boolean(),
        GoesForFastTable: faker.randomGenerator.boolean(),
        IsAlcoholicProduct: faker.randomGenerator.boolean(),
        childsComposition: makeProductsCompositionsEntity(isOptionalItem: true),
      ),
      ProductModel(
        MaximumQuantityForSale: faker.randomGenerator.decimal(),
        ProductComplement: faker.randomGenerator.string(10),
        ProductsId: faker.randomGenerator.integer(20),
        InternalCodeOnERP: faker.randomGenerator.integer(20),
        InternalCodeOfProductOnERP: faker.randomGenerator.integer(20),
        EnterpriseId: faker.randomGenerator.integer(20),
        FamilyCode: faker.randomGenerator.integer(20),
        DepartmentCode: faker.randomGenerator.integer(20),
        SectionCode: faker.randomGenerator.integer(20),
        GroupCode: faker.randomGenerator.integer(20),
        SubGroupCode: faker.randomGenerator.integer(20),
        CofinsType: faker.randomGenerator.integer(20),
        PisType: faker.randomGenerator.integer(20),
        ProductIsFatherComposition: faker.randomGenerator.integer(20),
        QuantityMinimumWholeSale: faker.randomGenerator.decimal(),
        QuantityMinimumWholeSaleByClass: faker.randomGenerator.decimal(),
        BalanceTare: faker.randomGenerator.decimal(),
        StockQuantity: faker.randomGenerator.decimal(),
        SaleRetailPrice: faker.randomGenerator.decimal(),
        PercImpNBPTNational: faker.randomGenerator.decimal(),
        SaleRetailPraticed: faker.randomGenerator.decimal(),
        CofinsPercentage: faker.randomGenerator.decimal(),
        PisPercentage: faker.randomGenerator.decimal(),
        PackingQuantity: faker.randomGenerator.decimal(),
        OfferRetailPrice: faker.randomGenerator.decimal(),
        WholeSalePrice: faker.randomGenerator.decimal(),
        WholeOfferPrice: faker.randomGenerator.decimal(),
        OfferECommercePrice: faker.randomGenerator.decimal(),
        SaleECommercePrice: faker.randomGenerator.decimal(),
        LiquidCost: faker.randomGenerator.decimal(),
        LiquidCostMiddle: faker.randomGenerator.decimal(),
        LiquidCostReal: faker.randomGenerator.decimal(),
        RepositionCost: faker.randomGenerator.decimal(),
        RepositionCostMiddle: faker.randomGenerator.decimal(),
        RepositionCostReal: faker.randomGenerator.decimal(),
        IcmsAliquot: faker.randomGenerator.decimal(),
        IcmsIVAMargin: faker.randomGenerator.decimal(),
        IcmsReductionMargin: faker.randomGenerator.decimal(),
        IcmsStave: faker.randomGenerator.decimal(),
        PercImpNBPTState: faker.randomGenerator.decimal(),
        PercImpNBPTMunicipal: faker.randomGenerator.decimal(),
        CFOP: faker.randomGenerator.string(10),
        FiscalClassificationNCM: faker.randomGenerator.string(10),
        TributarySituationCode: faker.randomGenerator.string(10),
        CSTPisCofins: faker.randomGenerator.string(10),
        CodeClass: faker.randomGenerator.string(10),
        DepartmentName: faker.randomGenerator.string(10),
        SectionName: faker.randomGenerator.string(10),
        DateOfLastChanged: faker.randomGenerator.string(10),
        GroupName: faker.randomGenerator.string(10),
        SaleRetailPraticedString: faker.randomGenerator.string(10),
        PriceLookupCode: faker.randomGenerator.string(10),
        PersonalizedCode: faker.randomGenerator.string(10),
        EanCode: faker.randomGenerator.string(10),
        Name: faker.randomGenerator.string(10),
        NameComplete: faker.randomGenerator.string(10),
        NameReduced: faker.randomGenerator.string(10),
        PackingAbbreviation: faker.randomGenerator.string(10),
        AllowFractionate: faker.randomGenerator.boolean(),
        IsBalance: faker.randomGenerator.boolean(),
        CanBeWeightyInPdv: faker.randomGenerator.boolean(),
        IsPromoCombox: faker.randomGenerator.boolean(),
        QuantityInBalance: faker.randomGenerator.boolean(),
        AllowQuantityInPdv: faker.randomGenerator.boolean(),
        GoesForFastTable: faker.randomGenerator.boolean(),
        IsAlcoholicProduct: faker.randomGenerator.boolean(),
        childsComposition: makeProductsCompositionsEntity(isOptionalItem: true),
      ),
    ];
  }

  static PrintedViewModel makePrintedViewModel() {
    return PrintedViewModel(
      Products: makePrintedProductsViewModel(),
      PersonalizedCode: faker.randomGenerator.string(10),
      TotalLiquid: faker.randomGenerator.decimal().toString(),
      DeliveryControl: faker.randomGenerator.string(10),
      DateOfCreation: faker.randomGenerator.string(10),
      DateHourOfCreation: faker.randomGenerator.string(10),
      FlagStatus: faker.randomGenerator.string(10),
      EnterpriseId: faker.randomGenerator.string(10),
      RequestType: faker.randomGenerator.string(10),
      IsCancelled: faker.randomGenerator.string(10),
      IsUsing: faker.randomGenerator.string(10),
      Peoples: faker.randomGenerator.string(10),
      SaleRequestId: faker.randomGenerator.integer(100).toString(),
      FlagOrigin: faker.randomGenerator.string(10),
      IncrementType: faker.randomGenerator.integer(2, min: 1).toString(),
      IncrementValue: faker.randomGenerator.decimal().toString(),
    );
  }

  static List<PrintedProductsViewModel> makePrintedProductsViewModel() {
    return [
      PrintedProductsViewModel(
        Products: makeProductsViewModel(),
        SaleRequestProductId: faker.randomGenerator.string(10),
        ProductPriceLookUpCode: faker.randomGenerator.string(10),
        Value: faker.randomGenerator.string(10),
        Quantity: faker.randomGenerator.string(10),
        QuantityString: faker.randomGenerator.string(10),
        UserId: faker.randomGenerator.string(10),
        DateHourOfCreation: faker.randomGenerator.string(10),
        IsCancelled: faker.randomGenerator.string(10),
        IsDelivered: faker.randomGenerator.string(10),
        IsPrinted: faker.randomGenerator.string(10),
        ProductionStatus: faker.randomGenerator.string(10),
        TotalLiquid: faker.randomGenerator.string(10),
        ProductInternalCodeOnErp: faker.randomGenerator.string(10),
        SaleRequestId: faker.randomGenerator.string(10),
      ),
      PrintedProductsViewModel(
        Products: makeProductsViewModel(),
        SaleRequestProductId: faker.randomGenerator.string(10),
        ProductPriceLookUpCode: faker.randomGenerator.string(10),
        Value: faker.randomGenerator.string(10),
        Quantity: faker.randomGenerator.string(10),
        QuantityString: faker.randomGenerator.string(10),
        UserId: faker.randomGenerator.string(10),
        DateHourOfCreation: faker.randomGenerator.string(10),
        IsCancelled: faker.randomGenerator.string(10),
        IsDelivered: faker.randomGenerator.string(10),
        IsPrinted: faker.randomGenerator.string(10),
        ProductionStatus: faker.randomGenerator.string(10),
        TotalLiquid: faker.randomGenerator.string(10),
        ProductInternalCodeOnErp: faker.randomGenerator.string(10),
        SaleRequestId: faker.randomGenerator.string(10),
      ),
    ];
  }

  static SaleRequestTempEntity makeApiSaleRequestEntity() {
    return SaleRequestTempEntity(
      Peoples: faker.randomGenerator.integer(100),
      SellerCode: faker.randomGenerator.integer(100).toString(),
      Products: const [],
      SaleRequestTempId: faker.randomGenerator.integer(10),
      PersonalizedCode: faker.randomGenerator.string(10),
      EnterpriseId: faker.randomGenerator.integer(3),
      TotalLiquid: faker.randomGenerator.decimal(),
      DeliveryControl: faker.randomGenerator.integer(5),
      CovenantCode: faker.randomGenerator.integer(5),
      CustomerCode: faker.randomGenerator.integer(5),
      Comments: faker.randomGenerator.string(50),
      IncrementValue: faker.randomGenerator.decimal(min: 0.01),
      IncrementType: faker.randomGenerator.integer(2, min: 1),
    );
  }

  static PrintedEntity makePrintedProductsEntity({
    int? incrementType,
  }) {
    return PrintedEntity(
      Products: [
        PrintedProductsEntity(
          Product: makeProductsEntitys()[0],
          ProductPriceLookUpCode: faker.randomGenerator.string(7),
          DateHourOfCreation: faker.date.dateTime().toIso8601String(),
          Comments: faker.randomGenerator.string(10),
          UserId: faker.randomGenerator.integer(10),
          ProductionStatus: faker.randomGenerator.integer(10),
          SaleRequestProductId: faker.randomGenerator.integer(10),
          ProductInternalCodeOnErp: faker.randomGenerator.integer(10),
          SaleRequestId: faker.randomGenerator.integer(10),
          IsPrinted: faker.randomGenerator.boolean(),
          IsCancelled: faker.randomGenerator.boolean(),
          IsDelivered: faker.randomGenerator.boolean(),
          QuantityString: faker.randomGenerator.integer(10).toString(),
          Quantity: faker.randomGenerator.decimal(),
          Value: faker.randomGenerator.decimal(),
          TotalLiquid: faker.randomGenerator.decimal(),
        ),
      ],
      IncrementType: incrementType ?? faker.randomGenerator.integer(2, min: 1),
      IncrementValue: faker.randomGenerator.decimal(),
      PersonalizedCode: faker.randomGenerator.string(10),
      DateOfCreation: faker.randomGenerator.string(10),
      FlagStatus: faker.randomGenerator.string(10),
      DateHourOfCreation: faker.date.random.toString(),
      EnterpriseId: faker.randomGenerator.integer(3),
      RequestType: faker.randomGenerator.string(10),
      IsCancelled: faker.randomGenerator.boolean(),
      IsUsing: faker.randomGenerator.boolean(),
      TotalLiquid: faker.randomGenerator.decimal(),
      Peoples: faker.randomGenerator.integer(10),
      SaleRequestId: faker.randomGenerator.integer(10),
      FlagOrigin: faker.randomGenerator.integer(10),
      DeliveryControl: faker.randomGenerator.integer(10),
    );
  }

  static SaleRequestTempProductsViewModel
      makeSaleRequestTempProductsViewModel() =>
          SaleRequestTempProductsViewModel(
            Comments: faker.randomGenerator.string(10),
            Product: makeProductsViewModel(),
            SaleRequestProductTempId:
                faker.randomGenerator.integer(10).toString(),
            ProductPriceLookUpCode:
                faker.randomGenerator.integer(10).toString(),
            SaleRequestTempId: faker.randomGenerator.integer(10).toString(),
            ProductInternalCodeOnErp:
                faker.randomGenerator.integer(10).toString(),
            IsPrinted: faker.randomGenerator.boolean().toString(),
            TotalLiquid: faker.randomGenerator.decimal().toString(),
            Quantity: faker.randomGenerator.decimal().toString(),
            Value: faker.randomGenerator.decimal().toString(),
            SaleRequestProductIdOfFather: null,
            ProductIsFatherComposition: null,
          );

  static UpdateSaleRequestTempEntity makeUpdateSaleRequestTempEntity() {
    final products = [makeUpdateSaleRequestTempProductEntity()];

    return UpdateSaleRequestTempEntity(
      SellerCode: faker.randomGenerator.integer(100).toString(),
      DeliveryControl: faker.randomGenerator.integer(5),
      EnterpriseId: faker.randomGenerator.integer(5),
      SaleRequestTempId: faker.randomGenerator.integer(5),
      PersonalizedCode: faker.randomGenerator.integer(3).toString(),
      TotalLiquid: products.fold(
          0.0, (previousValue, element) => element.TotalLiquid + previousValue),
      Products: products,
      Comments: faker.randomGenerator.string(10),
      Peoples: faker.randomGenerator.integer(100),
      CovenantCode: faker.randomGenerator.integer(100),
      CustomerCode: faker.randomGenerator.integer(100),
      IncrementValue: faker.randomGenerator.decimal(),
      IncrementType: faker.randomGenerator.integer(2, min: 1),
    );
  }

  static UpdateSaleRequestTempProductEntity
      makeUpdateSaleRequestTempProductEntity() {
    double quantity = faker.randomGenerator.decimal();
    double value = faker.randomGenerator.decimal();

    return UpdateSaleRequestTempProductEntity(
      ProductPriceLookUpCode: faker.randomGenerator.integer(7).toString(),
      ProductInternalCodeOnErp: faker.randomGenerator.integer(10),
      SaleRequestTempId: faker.randomGenerator.integer(10),
      Quantity: quantity,
      TotalLiquid: quantity * value,
      Value: value,
      Comments: faker.randomGenerator.string(10),
      SaleRequestProductIdOfFather: null,
      ProductIsFatherComposition: null,
    );
  }

  static SaleRequestTempEntity makeSaleRequestTempEntity(int? tableNumber) =>
      SaleRequestTempEntity(
        Peoples: faker.randomGenerator.integer(100),
        SellerCode: faker.randomGenerator.integer(100).toString(),
        Products: [makeSaleRequestTempProductEntity()],
        SaleRequestTempId: faker.randomGenerator.integer(3),
        EnterpriseId: faker.randomGenerator.integer(3),
        DeliveryControl: tableNumber ?? 0,
        PersonalizedCode: faker.randomGenerator.integer(3).toString(),
        TotalLiquid: faker.randomGenerator.decimal(),
        Comments: faker.randomGenerator.string(10),
        CustomerCode: faker.randomGenerator.integer(3),
        CovenantCode: faker.randomGenerator.integer(3),
        IncrementType:
            EnterpriseDataBuilder.enterpriseDataEntity?.serviceChargeType,
        IncrementValue: EnterpriseDataBuilder
            .enterpriseDataEntity?.serviceChargePercentageOrValue,
      );

  static SaleRequestTempProductEntity makeSaleRequestTempProductEntity() =>
      SaleRequestTempProductEntity(
        Product: makeProductsEntitys()[0],
        IsPrinted: faker.randomGenerator.boolean(),
        SaleRequestProductTempId: faker.randomGenerator.integer(5),
        SaleRequestTempId: faker.randomGenerator.integer(5),
        ProductInternalCodeOnErp: faker.randomGenerator.integer(5),
        TotalLiquid: faker.randomGenerator.decimal(),
        Quantity: faker.randomGenerator.decimal(),
        Value: faker.randomGenerator.decimal(),
        ProductPriceLookUpCode: faker.randomGenerator.integer(5).toString(),
        Comments: faker.randomGenerator.string(10),
        SaleRequestProductIdOfFather: null,
        ProductIsFatherComposition: null,
      );

  static TicketIsPermittedEntity makeTicketIsPermittedEntity() =>
      TicketIsPermittedEntity(
        TicketAccessControlId: faker.randomGenerator.integer(999),
        Number: faker.randomGenerator.integer(999).toString(),
        Barcode: faker.randomGenerator.integer(999).toString(),
        DateHourLastRelease: null,
        RefIdNumber: null,
      );

  static List<ProductCompositionEntity> makeProductsCompositionsEntity(
          {required bool isOptionalItem}) =>
      [
        ProductCompositionEntity(
          ProductCompositionId: faker.randomGenerator.integer(99),
          EnterpriseId: faker.randomGenerator.integer(99),
          InternalCodeOnERPCodeFather: faker.randomGenerator.integer(99),
          InternalCodeOnERPCodeChild: faker.randomGenerator.integer(99),
          PluChild: faker.randomGenerator.string(10),
          ChildName: faker.randomGenerator.string(10),
          Quantity: faker.randomGenerator.decimal(),
          SalePrice: faker.randomGenerator.decimal(),
          OfferPrice: faker.randomGenerator.decimal(),
          IncrementValue: faker.randomGenerator.decimal(),
          ProductOptions: faker.randomGenerator.string(10),
          IsOptionalItem: isOptionalItem,
          comment: faker.randomGenerator.string(10),
          indexOfSelectedChild: null,
        ),
        ProductCompositionEntity(
          ProductCompositionId: faker.randomGenerator.integer(99),
          EnterpriseId: faker.randomGenerator.integer(99),
          InternalCodeOnERPCodeFather: faker.randomGenerator.integer(99),
          InternalCodeOnERPCodeChild: faker.randomGenerator.integer(99),
          PluChild: faker.randomGenerator.string(10),
          ChildName: faker.randomGenerator.string(10),
          Quantity: faker.randomGenerator.decimal(),
          SalePrice: faker.randomGenerator.decimal(),
          OfferPrice: faker.randomGenerator.decimal(),
          IncrementValue: faker.randomGenerator.decimal(),
          ProductOptions: faker.randomGenerator.string(10),
          IsOptionalItem: isOptionalItem,
          comment: faker.randomGenerator.string(10),
          indexOfSelectedChild: null,
        ),
      ];

  static ProductCompositionViewModel makeProductCompositionViewModel({
    required double quantity,
    required double salePrice,
    required double offerPrice,
    required double fatherIncrement,
    required double childIncrement,
    required bool isOptionalItem,
    required int? indexOfSelectedChild,
    required bool insertChilds,
  }) =>
      ProductCompositionViewModel(
        ProductCompositionId: "1",
        EnterpriseId: "1",
        InternalCodeOnERPCodeFather: "1",
        InternalCodeOnERPCodeChild: "1",
        PluChild: "PluChild",
        ChildName: "ChildName",
        Quantity: quantity.toString(),
        SalePrice: salePrice.toString(),
        OfferPrice: offerPrice.toString(),
        IncrementValue: fatherIncrement.toString(),
        IsOptionalItem: isOptionalItem.toString(),
        ProductOptions: "",
        indexOfSelectedChild: indexOfSelectedChild,
        childs: !insertChilds
            ? []
            : [
                ProductCompositionViewModel(
                  ProductCompositionId: "1",
                  EnterpriseId: "1",
                  InternalCodeOnERPCodeFather: "1",
                  InternalCodeOnERPCodeChild: "1",
                  PluChild: "PluChild",
                  ChildName: "ChildName",
                  Quantity: quantity.toString(),
                  SalePrice: salePrice.toString(),
                  OfferPrice: offerPrice.toString(),
                  IncrementValue: childIncrement.toString(),
                  IsOptionalItem: isOptionalItem.toString(),
                  ProductOptions: "",
                  indexOfSelectedChild: indexOfSelectedChild,
                  childs: const [],
                  commentFather: "",
                )
              ],
        commentFather: "",
      );

  static PrintRequestEntity makePrintRequestEntity() => PrintRequestEntity(
        dates: [
          "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
        ],
        timesUsed: 1,
      );

  static CartProductEntity makeCartProductEntity({
    required int maximumProductQuantity,
    required int minimumProductQuantity,
    bool? generateChilds,
  }) {
    double productQuantity = faker.randomGenerator
        .integer(maximumProductQuantity, min: minimumProductQuantity)
        .toDouble();

    return CartProductEntity(
      Product: makeProductsViewModel(
        insertChildsComposition: generateChilds,
        isOptionalChilds: true,
        maximumProductQuantity: maximumProductQuantity,
        productQuantity: productQuantity,
      ).toEntity(),
      Comments: null,
      TotalLiquid: faker.randomGenerator.decimal(),
      Quantity: productQuantity,
      Value: faker.randomGenerator.decimal(),
      ProductPriceLookUpCode: faker.randomGenerator.string(20),
    );
  }

  static ExpansibleGroupFromProductViewModel
      makeExpansibleGroupFromProductViewModel({bool? selected = false}) =>
          ExpansibleGroupFromProductViewModel(
            GroupName: faker.randomGenerator.string(10),
            ProductName: faker.randomGenerator.string(10),
            selected: selected!,
            ExpansibleGroupId: faker.randomGenerator.integer(100).toString(),
            ProductInternalCodeOnErp:
                faker.randomGenerator.integer(100).toString(),
          );

  static CommandEntity makeCommandEntity([bool? isFixedCommandNumber]) =>
      CommandEntity(
        commandNumber: faker.randomGenerator.integer(100).toString(),
        isFixedCommandNumber: isFixedCommandNumber == true,
      );

  static List<ExpansibleGroupFromProductsCompleteEntity>
      makeExpansibleGroupFromProductCompleteEntity(
    ProductsViewModel product,
  ) =>
          [
            ExpansibleGroupFromProductsCompleteEntity(
              ExpansibleGroupId: faker.randomGenerator.integer(100),
              ProductInternalCodeOnErp: product.InternalCodeOnERP!.toInt(),
              GroupName: faker.randomGenerator.string(10),
              ProductName: product.Name,
            ),
          ];

  static SellerEntity makeSellerEntity() => SellerEntity(
        SellersId: faker.randomGenerator.integer(100),
        EnterpriseId: faker.randomGenerator.integer(100),
        Name: faker.randomGenerator.string(10),
        PersonalizedCode: faker.randomGenerator.string(10),
      );

  static SellersViewModel makeSellersViewModel() => SellersViewModel(
        SellersId: faker.randomGenerator.integer(100),
        EnterpriseId: faker.randomGenerator.integer(100),
        PersonalizedCode: faker.randomGenerator.integer(100).toString(),
        Name: faker.randomGenerator.string(10),
      );

  static List<SuggestionSaleEntity> makeSuggestionsSaleEntitys() => [
        SuggestionSaleEntity(
          ProductPackingCode: faker.randomGenerator.integer(100),
          ProductPackingCodeSuggestionForSale:
              faker.randomGenerator.integer(100),
        )
      ];

  static EnterpriseConcentradorParametersEntity
      makeEnterpriseConcentradorParametersEntity() =>
          EnterpriseConcentradorParametersEntity(
            enterprise: makeEnterpriseConcentradorEntity(),
            useBalanceOnPdv: faker.randomGenerator.boolean(),
            balanceLabelProductCodeWithCheckerDigit:
                faker.randomGenerator.boolean(),
            allowDiscountOnOffer: faker.randomGenerator.boolean(),
            allowDiscountOnWholeSale: faker.randomGenerator.boolean(),
            allowManualDiscountOnAutomaticDiscount:
                faker.randomGenerator.boolean(),
            useDiscountLiquidFromSaleNegotiation:
                faker.randomGenerator.boolean(),
            acceptCheckCustomerNotKnow: faker.randomGenerator.boolean(),
            useFinalizationCheckLikePortion: faker.randomGenerator.boolean(),
            allowParcelling: faker.randomGenerator.boolean(),
            openCashDrawerOnlyForMoney: faker.randomGenerator.boolean(),
            showValuesOnBleeding: faker.randomGenerator.boolean(),
            showOnlyCardValuesOnBleeding: faker.randomGenerator.boolean(),
            showPOSValuesOnBleeding: faker.randomGenerator.boolean(),
            limitValueToBleedByCashierBalanceValues:
                faker.randomGenerator.boolean(),
            blockadeCashierOnLimitBleedingExceed:
                faker.randomGenerator.boolean(),
            considerBottomCashierValueOnBleeding:
                faker.randomGenerator.boolean(),
            askSaleIsTravel: faker.randomGenerator.boolean(),
            useDeliveryControl: faker.randomGenerator.boolean(),
            useDeliveryControlFastTable: faker.randomGenerator.boolean(),
            useDeliveryControlAskFlagNumber: faker.randomGenerator.boolean(),
            requestCustomerToDeliveryType: faker.randomGenerator.boolean(),
            useGiftControl: faker.randomGenerator.boolean(),
            separateDeliveryControlPayments: faker.randomGenerator.boolean(),
            controlCashDrawerOpened: faker.randomGenerator.boolean(),
            allowCancelAllItensOnCoupon: faker.randomGenerator.boolean(),
            blockadeSaleRequestTaxPayerInterState:
                faker.randomGenerator.boolean(),
            blockadeSaleRequestNotPrint: faker.randomGenerator.boolean(),
            obligatoryCovenantWhenCustomer: faker.randomGenerator.boolean(),
            printProductCancelledAfterSale: faker.randomGenerator.boolean(),
            paymentFinalizationSelectMoneyAutomatically:
                faker.randomGenerator.boolean(),
            fillAutomaticallyCPFCNPJWithCustomerData:
                faker.randomGenerator.boolean(),
            showPortionsNumberWithGride: faker.randomGenerator.boolean(),
            mercaFacilDiscountsIsEnabled: faker.randomGenerator.boolean(),
            bonifiQIsEnabled: faker.randomGenerator.boolean(),
            cresceVendasIsEnabled: faker.randomGenerator.boolean(),
            useCupomPrintSimplify: faker.randomGenerator.boolean(),
            useCupomPrintAllProductName: faker.randomGenerator.boolean(),
            printDiscountProductsOnCoupon: faker.randomGenerator.boolean(),
            allowNFCeEmission: faker.randomGenerator.boolean(),
            productSearchPluCodeWithDigit: faker.randomGenerator.boolean(),
            disableSearchDotProductDigit: faker.randomGenerator.boolean(),
            disableSearchPluForProductEan: faker.randomGenerator.boolean(),
            showStockValueOnProductConsult: faker.randomGenerator.boolean(),
            allowMaxQtdItemExceedAuthorization: faker.randomGenerator.boolean(),
            sATSharingBlockadeForTEF: faker.randomGenerator.boolean(),
            sATSharingBlockadeForCustomerIdentifier:
                faker.randomGenerator.boolean(),
            requestSalePriceTypeOnInitialSale: faker.randomGenerator.boolean(),
            showWholeSalePriceOnProductConsult: faker.randomGenerator.boolean(),
            showCustomerAddress: faker.randomGenerator.boolean(),
            showCustomerTelephone: faker.randomGenerator.boolean(),
            activePromotionChampionMarks: faker.randomGenerator.boolean(),
            tEFRequestOriginParceling: faker.randomGenerator.boolean(),
            useControlCashierClose: faker.randomGenerator.boolean(),
            use24HsCashierMovement: faker.randomGenerator.boolean(),
            xavierCardIsEnabled: faker.randomGenerator.boolean(),
            vidaMaisCardIsEnabled: faker.randomGenerator.boolean(),
            parametersId: faker.randomGenerator.integer(100),
            balanceLabelProductCodeSize: faker.randomGenerator.integer(100),
            balanceLabelValueOrQuantityType: faker.randomGenerator.integer(100),
            roundingType: faker.randomGenerator.integer(100),
            internalCustomerCode: faker.randomGenerator.integer(100),
            allowCancelOnlyLastSale: faker.randomGenerator.integer(100),
            printCouponModel: faker.randomGenerator.integer(100),
            printCouponTEFOrder: faker.randomGenerator.integer(100),
            useMotiveCancellationType: faker.randomGenerator.integer(100),
            useMotiveJustificationTypeOnBleeding:
                faker.randomGenerator.integer(100),
            useMotiveJustificationTypeOnSaleDiscount:
                faker.randomGenerator.integer(100),
            discountTypeAllowed: faker.randomGenerator.integer(100),
            digitalWalletShowQRCodePayment: faker.randomGenerator.integer(100),
            consumerCPFCNPJRequestType: faker.randomGenerator.integer(100),
            saleRequestSellerRequestType: faker.randomGenerator.integer(100),
            saleRequestOrigin: faker.randomGenerator.integer(100),
            finalizationPOSRequestNSUType: faker.randomGenerator.integer(100),
            parcelMaxPortionsNumber: faker.randomGenerator.integer(100),
            pdvAspectViwModelType: faker.randomGenerator.integer(100),
            saleProductMaxQtdItem: faker.randomGenerator.integer(100),
            urlSATSharingTotalCouponGroup: faker.randomGenerator.integer(100),
            daysToMaintainHistory: faker.randomGenerator.integer(100),
            bleedingPrintNumber: faker.randomGenerator.integer(100),
            printNumberForPOSVoucher: faker.randomGenerator.integer(100),
            printNumberForCovenantVoucher: faker.randomGenerator.integer(100),
            printNumberForCreditDevolutionVoucher:
                faker.randomGenerator.integer(100),
            printNumberForExchangeInformation:
                faker.randomGenerator.integer(100),
            printNumberForDeliveryVoucher: faker.randomGenerator.integer(100),
            userAuthenticationModelType: faker.randomGenerator.integer(100),
            parkingControlType: faker.randomGenerator.integer(100),
            parkingControlIPPort: faker.randomGenerator.integer(100),
            balanceMask: faker.randomGenerator.string(10),
            celtaBSUrlCCS: faker.randomGenerator.string(10),
            celtaBSUrlBSF: faker.randomGenerator.string(10),
            celtaBSCrossIdentity: faker.randomGenerator.string(10),
            saleMsgInitial: faker.randomGenerator.string(10),
            productInternalCodeToDonation: faker.randomGenerator.string(10),
            sitefMsgVisor: faker.randomGenerator.string(10),
            sitefIPNumber: faker.randomGenerator.string(10),
            sitefEnterpriseCode: faker.randomGenerator.string(10),
            sitefCustomerCode: faker.randomGenerator.string(10),
            sitefCliSitefAdditionalDataIni: faker.randomGenerator.string(10),
            mercaFacilDiscountsTokenApi: faker.randomGenerator.string(10),
            bonifiQUser: faker.randomGenerator.string(10),
            bonifiQPassword: faker.randomGenerator.string(10),
            cresceVendasUser: faker.randomGenerator.string(10),
            cresceVendasPassword: faker.randomGenerator.string(10),
            cupomMsgBottom: faker.randomGenerator.string(10),
            cupomMsgExchangeInformation: faker.randomGenerator.string(10),
            pathToGenerateXmlSATNFCe: faker.randomGenerator.string(10),
            saleProductBalanceMaxQtdItem: faker.randomGenerator.string(10),
            imageMarketingSecondsForIdleTime: faker.randomGenerator.string(10),
            imageMarketingSecondsForShowEachImage:
                faker.randomGenerator.string(10),
            xavierCardUrl: faker.randomGenerator.string(10),
            xavierCardEnterpriseCode: faker.randomGenerator.string(10),
            xavierCardUserCode: faker.randomGenerator.string(10),
            xavierCardUserPassword: faker.randomGenerator.string(10),
            vidaMaisCardUserCode: faker.randomGenerator.string(10),
            vidaMaisCardUserPassword: faker.randomGenerator.string(10),
            vidaMaisCardSellerCode: faker.randomGenerator.string(10),
            parkingControlIPAddress: faker.randomGenerator.string(10),
          );

  static makeEnterpriseConcentradorEntity() => EnterpriseConcentradorEntity(
        enterpriseId: faker.randomGenerator.integer(100),
        enterpriseCode: faker.randomGenerator.integer(100),
        federalSimpleType: faker.randomGenerator.integer(100),
        cnpj: faker.randomGenerator.string(100),
        formatedCnpj: faker.randomGenerator.string(100),
        inscriptionState: faker.randomGenerator.string(100),
        passwordMonth: faker.randomGenerator.string(100),
        fantasyName: faker.randomGenerator.string(100),
        socialName: faker.randomGenerator.string(100),
        addressName: faker.randomGenerator.string(100),
        addressDistrict: faker.randomGenerator.string(100),
        addressCity: faker.randomGenerator.string(100),
        addressIBGECityCode: faker.randomGenerator.string(100),
        addressZip: faker.randomGenerator.string(100),
        addressState: faker.randomGenerator.string(100),
        nFCeIdentificationCode: faker.randomGenerator.string(100),
        nFCeSecurityCode: faker.randomGenerator.string(100),
        urlSefazConsultNfce: faker.randomGenerator.string(100),
        urlSefazConsultQRCodeNfce: faker.randomGenerator.string(100),
        addressFull: faker.randomGenerator.string(100),
        personalizedCode: faker.randomGenerator.string(100),
        telephone: faker.randomGenerator.string(100),
        enterpriseString: faker.randomGenerator.string(100),
        considerIcmsForCalculateBaseOfPisCofins:
            faker.randomGenerator.boolean(),
        saleInRetail: faker.randomGenerator.boolean(),
        saleInWholeSale: faker.randomGenerator.boolean(),
        saleInECommerce: faker.randomGenerator.boolean(),
      );

  static List<CustomerEntity> makeCustomersEntitys({
    bool? hasPasswod = true,
  }) =>
      [
        CustomerEntity(
          Code: faker.randomGenerator.integer(100),
          PersonalizedCode: faker.randomGenerator.string(100),
          Name: faker.randomGenerator.string(100),
          ReducedName: faker.randomGenerator.string(100),
          CpfCnpjNumber: faker.randomGenerator.integer(100).toString(),
          RegistrationNumber: faker.randomGenerator.string(100),
          DateOfBirth: faker.randomGenerator.string(100),
          SexType: faker.randomGenerator.string(100),
          PersonType: faker.randomGenerator.string(100),
          HasPassword:
              hasPasswod == true ? faker.randomGenerator.boolean() : null,
          Emails: [
            faker.randomGenerator.string(100),
            faker.randomGenerator.string(100),
          ],
          Telephones: [
            _makeTelephoneEntity(),
            _makeTelephoneEntity(),
          ],
          Addresses: [
            _makeAdressEntity(),
            _makeAdressEntity(),
          ],
          CustomerCovenants: const [],
        ),
      ];

  static _makeTelephoneEntity() => TelephoneEntity(
        AreaCode: faker.randomGenerator.string(100),
        PhoneNumber: faker.randomGenerator.string(100),
      );

  static _makeAdressEntity() => AddressEntity(
        Zip: faker.randomGenerator.string(100),
        Address: faker.randomGenerator.string(100),
        Number: faker.randomGenerator.string(100),
        District: faker.randomGenerator.string(100),
        City: faker.randomGenerator.string(100),
        State: faker.randomGenerator.string(100),
        Complement: faker.randomGenerator.string(100),
        Reference: faker.randomGenerator.string(100),
      );

  static makeSaleRequestEntity() => SaleRequestEntity(
        Products: [makeSaleRequestProductEntity()],
        DateOfCreation: faker.randomGenerator.string(10),
        DateHourOfCreation: faker.randomGenerator.string(10),
        RequestType: faker.randomGenerator.string(10),
        SellerCode: faker.randomGenerator.string(10),
        FlagStatus: faker.randomGenerator.string(10),
        Comments: faker.randomGenerator.string(10),
        PersonalizedCode: faker.randomGenerator.string(10),
        IsCancelled: faker.randomGenerator.boolean(),
        IsUsing: faker.randomGenerator.boolean(),
        TotalLiquid: faker.randomGenerator.decimal(),
        CovenantCode: faker.randomGenerator.integer(100),
        CustomerCode: faker.randomGenerator.integer(100),
        EnterpriseId: faker.randomGenerator.integer(100),
        Peoples: faker.randomGenerator.integer(100),
        FlagOrigin: faker.randomGenerator.integer(100),
        DeliveryControl: faker.randomGenerator.integer(100),
        SaleRequestId: faker.randomGenerator.integer(100),
        IncrementValue: faker.randomGenerator.decimal(),
        IncrementType: faker.randomGenerator.integer(100),
      );

  static SaleRequestProductEntity makeSaleRequestProductEntity() =>
      SaleRequestProductEntity(
        Product: makeProductsEntitys()[0],
        SaleMovementProductCompositionId: faker.randomGenerator.string(10),
        ProductPriceLookUpCode: faker.randomGenerator.string(10),
        QuantityString: faker.randomGenerator.string(10),
        Comments: faker.randomGenerator.string(10),
        DateHourOfCreation: faker.randomGenerator.string(10),
        IsCancelled: faker.randomGenerator.boolean(),
        IsDelivered: faker.randomGenerator.boolean(),
        IsPrinted: faker.randomGenerator.boolean(),
        SaleRequestProductId: faker.randomGenerator.integer(100),
        UserId: faker.randomGenerator.integer(100),
        ProductionStatus: faker.randomGenerator.integer(100),
        ProductInternalCodeOnErp: faker.randomGenerator.integer(100),
        SaleRequestId: faker.randomGenerator.integer(100),
        Value: faker.randomGenerator.decimal(),
        Quantity: faker.randomGenerator.decimal(),
        TotalLiquid: faker.randomGenerator.decimal(),
      );

  static makeSaleRequestModel({
    required int covenantCode,
    required int customerCode,
  }) =>
      SaleRequestModel(
        CovenantCode: covenantCode,
        CustomerCode: customerCode,
        Products: [
          SaleRequestProductModel.fromEntity(makeSaleRequestProductEntity()),
        ],
        DateOfCreation: faker.randomGenerator.string(10),
        DateHourOfCreation: faker.randomGenerator.string(10),
        RequestType: faker.randomGenerator.string(10),
        SellerCode: faker.randomGenerator.string(10),
        FlagStatus: faker.randomGenerator.string(10),
        Comments: faker.randomGenerator.string(10),
        PersonalizedCode: faker.randomGenerator.string(10),
        IsCancelled: faker.randomGenerator.boolean(),
        IsUsing: faker.randomGenerator.boolean(),
        TotalLiquid: faker.randomGenerator.decimal(),
        EnterpriseId: faker.randomGenerator.integer(100),
        Peoples: faker.randomGenerator.integer(100),
        FlagOrigin: faker.randomGenerator.integer(100),
        DeliveryControl: faker.randomGenerator.integer(100),
        SaleRequestId: faker.randomGenerator.integer(100),
        IncrementValue: faker.randomGenerator.decimal(),
        IncrementType: faker.randomGenerator.integer(2, min: 1),
      );

  static makeConcentratorFinaliztionModel() => ConcentratorFinalizationModel(
        FinalizationId: faker.randomGenerator.integer(100),
        PortionQuantity: faker.randomGenerator.integer(100),
        Value: faker.randomGenerator.decimal(),
        ValueLiquid: faker.randomGenerator.decimal(),
      );
}
