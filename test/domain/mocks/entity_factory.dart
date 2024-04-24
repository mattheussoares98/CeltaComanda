import 'package:clean_celta_mobile/data/models/models.dart';
import 'package:clean_celta_mobile/domain/entities/entities.dart';
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

  static List<ProductEntity> makeProducts() {
    return [
      ProductEntity(
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
        PameReduced: faker.randomGenerator.string(10),
        PackingAbbreviation: faker.randomGenerator.string(10),
      ),
      ProductEntity(
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
        PameReduced: faker.randomGenerator.string(10),
        PackingAbbreviation: faker.randomGenerator.string(10),
      ),
    ];
  }

  static List<ExpansibleGroupEntity> makeExpansibleGroupsEntity() {
    return [
      ExpansibleGroupEntity(
        Name: faker.randomGenerator.string(30),
        ExpansibleGroupId: faker.randomGenerator.integer(3),
        ExpansibleGroupType: faker.randomGenerator.integer(3),
        OrderClassification: faker.randomGenerator.integer(3),
      ),
      ExpansibleGroupEntity(
        Name: faker.randomGenerator.string(30),
        ExpansibleGroupId: faker.randomGenerator.integer(3),
        ExpansibleGroupType: faker.randomGenerator.integer(3),
        OrderClassification: faker.randomGenerator.integer(3),
      ),
    ];
  }

  static SaleRequestTempViewModel makeSaleRequestTempViewModel(
      List<ProductModel> products) {
    return SaleRequestTempViewModel(
      Products: products
          .map((e) => ProductsViewModel(
                SaleRetailPraticed: e.SaleRetailPraticed.toString(),
                EanCode: e.EanCode.toString(),
                PackingAbbreviation: e.PackingAbbreviation,
                Name: e.Name,
                PriceLookupCode: e.PriceLookupCode,
                ProductsId: e.ProductsId,
              ))
          .toList(),
      PersonalizedCode: faker.randomGenerator.string(10),
      EnterpriseId: faker.randomGenerator.integer(3),
      DeliveryControl: faker.randomGenerator.integer(3),
      TotalLiquid: faker.randomGenerator.decimal(min: 0.01),
    );
  }

  static ProductsViewModel makeProductViewModel() {
    return ProductsViewModel(
      SaleRetailPraticed: faker.randomGenerator.decimal(min: 0.01).toString(),
      PackingAbbreviation: faker.randomGenerator.string(10),
      Name: faker.food.random.string(10),
      EanCode: faker.randomGenerator.integer(20).toString(),
      PriceLookupCode: faker.randomGenerator.string(10),
      ProductsId: faker.randomGenerator.integer(10),
    );
  }

  static List<ProductModel> makeProductModel() {
    return [
      ProductModel(
        SaleRetailPraticed: faker.randomGenerator.decimal(min: 0.01),
        PackingAbbreviation: faker.randomGenerator.string(10),
        Name: faker.food.random.string(10),
        EanCode: faker.randomGenerator.integer(20).toString(),
        PriceLookupCode: faker.randomGenerator.string(10),
        ProductsId: faker.randomGenerator.integer(10),
      ),
      ProductModel(
        SaleRetailPraticed: faker.randomGenerator.decimal(min: 0.01),
        PackingAbbreviation: faker.randomGenerator.string(10),
        Name: faker.food.random.string(10),
        EanCode: faker.randomGenerator.integer(20).toString(),
        PriceLookupCode: faker.randomGenerator.string(10),
        ProductsId: faker.randomGenerator.integer(10),
      ),
    ];
  }

  static SaleRequestTempEntity makeApiSaleRequestEntity() {
    return SaleRequestTempEntity(
      Products: [],
      SaleRequestTempId: faker.randomGenerator.integer(10),
      PersonalizedCode: faker.randomGenerator.string(10),
      EnterpriseId: faker.randomGenerator.integer(3),
      TotalLiquid: faker.randomGenerator.decimal(),
      DeliveryControl: faker.randomGenerator.integer(5),
      Comments: faker.randomGenerator.string(50),
    );
  }
}
