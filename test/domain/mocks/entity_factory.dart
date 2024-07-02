import 'package:clean_celta_mobile/data/models/models.dart';
import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import 'package:faker/faker.dart';

class EntityFactory {
  static EnterpriseEntity makeEnterpriseData() {
    final String url = faker.internet.httpUrl();
    return EnterpriseEntity(
      url: url,
      enterpriseId: faker.randomGenerator.integer(3),
      enterpriseName: faker.company.name(),
    );
  }

  static List<ProductEntity> makeProductsEntitys({bool? isPromoCombox}) {
    return [
      ProductEntity(
        ProductComplement: faker.randomGenerator.string(10),
        IsPromoCombox: isPromoCombox ?? faker.randomGenerator.boolean(),
        ProductsId: faker.randomGenerator.integer(10),
        InternalCodeOnERP: faker.randomGenerator.integer(10),
        InternalCodeOfProductOnERP: faker.randomGenerator.integer(10),
        EenterpriseId: faker.randomGenerator.integer(10),
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
        CofinsType: faker.randomGenerator.integer(10),
        PisType: faker.randomGenerator.integer(10),
        ProductIsFatherComposition: faker.randomGenerator.integer(10),
        QuantityMinimumWholeSale: faker.randomGenerator.decimal(min: 5),
        QuantityMinimumWholeSaleByClass: faker.randomGenerator.decimal(min: 5),
        BalanceTare: faker.randomGenerator.decimal(min: 5),
        FamilyCode: faker.randomGenerator.integer(10),
        DepartmentCode: faker.randomGenerator.integer(10),
        SectionCode: faker.randomGenerator.integer(10),
        GroupCode: faker.randomGenerator.integer(10),
        SubGroupCode: faker.randomGenerator.integer(10),
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
      ),
      ProductEntity(
        ProductComplement: faker.randomGenerator.string(10),
        IsPromoCombox: isPromoCombox ?? faker.randomGenerator.boolean(),
        ProductsId: faker.randomGenerator.integer(10),
        InternalCodeOnERP: faker.randomGenerator.integer(10),
        InternalCodeOfProductOnERP: faker.randomGenerator.integer(10),
        EenterpriseId: faker.randomGenerator.integer(10),
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
        CofinsType: faker.randomGenerator.integer(10),
        PisType: faker.randomGenerator.integer(10),
        ProductIsFatherComposition: faker.randomGenerator.integer(10),
        QuantityMinimumWholeSale: faker.randomGenerator.decimal(min: 5),
        QuantityMinimumWholeSaleByClass: faker.randomGenerator.decimal(min: 5),
        BalanceTare: faker.randomGenerator.decimal(min: 5),
        FamilyCode: faker.randomGenerator.integer(10),
        DepartmentCode: faker.randomGenerator.integer(10),
        SectionCode: faker.randomGenerator.integer(10),
        GroupCode: faker.randomGenerator.integer(10),
        SubGroupCode: faker.randomGenerator.integer(10),
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
      ),
    ];
  }

  static List<ExpansibleGroupEntity> makeExpansibleGroupsEntity() {
    return [
      ExpansibleGroupEntity(
        Name: faker.randomGenerator.string(30),
        ExpansibleGroupId: faker.randomGenerator.integer(99),
        ExpansibleGroupType: faker.randomGenerator.integer(99),
        OrderClassification: faker.randomGenerator.integer(99),
      ),
      ExpansibleGroupEntity(
        Name: faker.randomGenerator.string(30),
        ExpansibleGroupId: faker.randomGenerator.integer(99),
        ExpansibleGroupType: faker.randomGenerator.integer(99),
        OrderClassification: faker.randomGenerator.integer(99),
      ),
    ];
  }

  static SaleRequestTempViewModel makeSaleRequestTempViewModel(
      List<ProductModel> products) {
    return SaleRequestTempViewModel(
      SaleRequestTempId: faker.randomGenerator.integer(3).toString(),
      Products: products
          .map((e) => SaleRequestTempProductsViewModel(
                Product: makeProductViewModel(),
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
              ))
          .toList(),
      PersonalizedCode: faker.randomGenerator.string(10),
      EnterpriseId: faker.randomGenerator.integer(3).toString(),
      DeliveryControl: faker.randomGenerator.integer(3).toString(),
      TotalLiquid: faker.randomGenerator.decimal(min: 0.01).toString(),
    );
  }

  static ProductsViewModel makeProductViewModel() {
    return ProductsViewModel(
      ProductComplement: faker.randomGenerator.string(10),
      IsPromoCombox: faker.randomGenerator.boolean().toString(),
      SaleRetailPraticed: faker.randomGenerator.decimal(min: 0.01).toString(),
      PackingAbbreviation: faker.randomGenerator.string(10),
      Name: faker.food.random.string(10),
      EanCode: faker.randomGenerator.integer(20).toString(),
      PriceLookupCode: faker.randomGenerator.string(10),
      ProductsId: faker.randomGenerator.integer(10).toString(),
      InternalCodeOnERP: faker.randomGenerator.integer(10).toString(),
      InternalCodeOfProductOnERP: faker.randomGenerator.string(10),
      EenterpriseId: faker.randomGenerator.string(10),
      PackingQuantity: faker.randomGenerator.string(10),
      OfferRetailPrice: faker.randomGenerator.string(10),
      WholeSalePrice: faker.randomGenerator.string(10),
      WholeOfferPrice: faker.randomGenerator.string(10),
      OfferECommercePrice: faker.randomGenerator.string(10),
      SaleECommercePrice: faker.randomGenerator.string(10),
      LiquidCost: faker.randomGenerator.string(10),
      LiquidCostMiddle: faker.randomGenerator.string(10),
      LiquidCostReal: faker.randomGenerator.string(10),
      RepositionCost: faker.randomGenerator.string(10),
      RepositionCostMiddle: faker.randomGenerator.string(10),
      RepositionCostReal: faker.randomGenerator.string(10),
      IcmsAliquot: faker.randomGenerator.string(10),
      IcmsIVAMargin: faker.randomGenerator.string(10),
      IcmsReductionMargin: faker.randomGenerator.string(10),
      IcmsStave: faker.randomGenerator.string(10),
      PercImpNBPTState: faker.randomGenerator.string(10),
      PercImpNBPTMunicipal: faker.randomGenerator.string(10),
      CofinsType: faker.randomGenerator.string(10),
      PisType: faker.randomGenerator.string(10),
      ProductIsFatherComposition: faker.randomGenerator.string(10),
      QuantityMinimumWholeSale: faker.randomGenerator.string(10),
      QuantityMinimumWholeSaleByClass: faker.randomGenerator.string(10),
      BalanceTare: faker.randomGenerator.string(10),
      FamilyCode: faker.randomGenerator.string(10),
      DepartmentCode: faker.randomGenerator.string(10),
      SectionCode: faker.randomGenerator.string(10),
      GroupCode: faker.randomGenerator.string(10),
      SubGroupCode: faker.randomGenerator.string(10),
      StockQuantity: faker.randomGenerator.string(10),
      AllowFractionate: faker.randomGenerator.string(10),
      IsBalance: faker.randomGenerator.string(10),
      CanBeWeightyInPdv: faker.randomGenerator.string(10),
      QuantityInBalance: faker.randomGenerator.string(10),
      AllowQuantityInPdv: faker.randomGenerator.string(10),
      GoesForFastTable: faker.randomGenerator.string(10),
      IsAlcoholicProduct: faker.randomGenerator.string(10),
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
    );
  }

  static List<ProductModel> makeProductModel() {
    return [
      ProductModel(
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
      ),
      ProductModel(
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
      ),
    ];
  }

  static PrintedViewModel makePrintedViewModel() {
    return PrintedViewModel(
      Products: makePrintedProductsViewModel(),
      PersonalizedCode: faker.randomGenerator.string(10),
      TotalLiquid: faker.randomGenerator.string(10),
      DeliveryControl: faker.randomGenerator.string(10),
      DateOfCreation: faker.randomGenerator.string(10),
      DateHourOfCreation: faker.randomGenerator.string(10),
      FlagStatus: faker.randomGenerator.string(10),
      EnterpriseId: faker.randomGenerator.string(10),
      RequestType: faker.randomGenerator.string(10),
      IsCancelled: faker.randomGenerator.string(10),
      IsUsing: faker.randomGenerator.string(10),
      Peoples: faker.randomGenerator.string(10),
      SaleRequestId: faker.randomGenerator.string(10),
      FlagOrigin: faker.randomGenerator.string(10),
    );
  }

  static List<PrintedProductsViewModel> makePrintedProductsViewModel() {
    return [
      PrintedProductsViewModel(
        Products: makeProductViewModel(),
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
        Products: makeProductViewModel(),
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
      Products: const [],
      SaleRequestTempId: faker.randomGenerator.integer(10),
      PersonalizedCode: faker.randomGenerator.string(10),
      EnterpriseId: faker.randomGenerator.integer(3),
      TotalLiquid: faker.randomGenerator.decimal(),
      DeliveryControl: faker.randomGenerator.integer(5),
      Comments: faker.randomGenerator.string(50),
    );
  }

  static PrintedEntity makePrintedProductsEntity() {
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
            Product: makeProductViewModel(),
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
          );

  static UpdateSaleRequestTempEntity makeUpdateSaleRequestTempEntity() {
    final products = [makeUpdateSaleRequestTempProductEntity()];

    return UpdateSaleRequestTempEntity(
      DeliveryControl: faker.randomGenerator.integer(5),
      EnterpriseId: faker.randomGenerator.integer(5),
      SaleRequestTempId: faker.randomGenerator.integer(5),
      PersonalizedCode: faker.randomGenerator.integer(3).toString(),
      TotalLiquid: products.fold(
          0.0, (previousValue, element) => element.TotalLiquid + previousValue),
      Products: products,
      Comments: faker.randomGenerator.string(10),
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
    );
  }

  static SaleRequestTempEntity makeSaleRequestTempEntity(int? tableNumber) =>
      SaleRequestTempEntity(
        Products: [makeSaleRequestTempProductEntity()],
        SaleRequestTempId: faker.randomGenerator.integer(3),
        EnterpriseId: faker.randomGenerator.integer(3),
        DeliveryControl: tableNumber ?? 0,
        PersonalizedCode: faker.randomGenerator.integer(3).toString(),
        TotalLiquid: faker.randomGenerator.decimal(),
        Comments: faker.randomGenerator.string(10),
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
      );

  static TicketIsPermittedEntity makeTicketIsPermittedEntity() =>
      TicketIsPermittedEntity(
        TicketAccessControlId: faker.randomGenerator.integer(999),
        Number: faker.randomGenerator.integer(999).toString(),
        Barcode: faker.randomGenerator.integer(9999999999999).toString(),
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
  }) =>
      CartProductEntity(
        Product: makeProductsEntitys()[0],
        Comments: null,
        TotalLiquid: faker.randomGenerator.decimal(),
        Quantity: faker.randomGenerator
            .integer(maximumProductQuantity, min: minimumProductQuantity)
            .toDouble(),
        Value: faker.randomGenerator.decimal(),
        ProductPriceLookUpCode: faker.randomGenerator.string(20),
      );

  static ConfirmedComboxViewModel makeConfirmedComboxViewModel({
    required List<ProductCompositionViewModel> products,
    required ProductsViewModel father,
    required double totalPrice,
    required double quantity,
  }) =>
      ConfirmedComboxViewModel(
        products: products
            .map((element) => ProductCompositionViewModel(
                  Quantity:
                      (element.Quantity!.toDouble() * quantity).toString(),
                  ProductCompositionId: element.ProductCompositionId,
                  EnterpriseId: element.EnterpriseId,
                  InternalCodeOnERPCodeFather:
                      element.InternalCodeOnERPCodeFather,
                  InternalCodeOnERPCodeChild:
                      element.InternalCodeOnERPCodeChild,
                  PluChild: element.PluChild,
                  ChildName: element.ChildName,
                  SalePrice: element.SalePrice,
                  OfferPrice: element.OfferPrice,
                  IncrementValue: element.IncrementValue,
                  IsOptionalItem: element.IsOptionalItem,
                  ProductOptions: element.ProductOptions,
                  childs: element.childs,
                  commentFather: element.commentFather,
                  indexOfSelectedChild: element.indexOfSelectedChild,
                ))
            .toList(),
        father: father,
        totalPrice: totalPrice,
        quantity: quantity,
      );

  static CommentViewModel makeCommentViewModel({bool? selected = false}) =>
      CommentViewModel(
        comment: faker.randomGenerator.string(10),
        selected: selected!,
      );
}
