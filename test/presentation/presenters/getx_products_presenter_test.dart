import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:faker/faker.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../ui/mocks/mocks.dart';

void main() {
  Get.testMode = true;
  WidgetsFlutterBinding.ensureInitialized();

  late GetxProductsPresenter sut;
  late ExpansibleGroupsPresenterSpy expansibleGroupsPresenter;

  late List<ProductEntity> products;
  late int expansibleGroupId;
  late String comments;

  late NavigateToSpy navigateTo;
  late LoadProductsSpy loadProducts;
  late UpdateSaleRequestTempSpy updateSaleRequestTemp;
  late LoadSaleRequestTempSpy loadSaleRequestTemp;
  late UpdateProductCommentSpy updateProductComment;

  setUp(() {
    expansibleGroupId = faker.randomGenerator.integer(3);
    loadProducts = LoadProductsSpy();
    products = EntityFactory.makeProductsEntitys();
    loadProducts.mockLoadProducts(products);
    navigateTo = NavigateToSpy();
    navigateTo.mockNavigate();
    comments = faker.randomGenerator.string(10);

    updateSaleRequestTemp = UpdateSaleRequestTempSpy();
    loadSaleRequestTemp = LoadSaleRequestTempSpy();
    expansibleGroupsPresenter = ExpansibleGroupsPresenterSpy();
    updateProductComment = UpdateProductCommentSpy();

    updateSaleRequestTemp.mockUpdateSaleRequestTemp();
    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();

    loadSaleRequestTemp
        .mockLoadSaleRequestTemp(EntityFactory.makeSaleRequestTempEntity());
    expansibleGroupsPresenter.commandNumberMock =
        faker.randomGenerator.integer(3).toString();

    sut = GetxProductsPresenter(
      navigateTo: navigateTo,
      loadProducts: loadProducts,
      updateSaleRequestTemp: updateSaleRequestTemp,
      loadSaleRequestTemp: loadSaleRequestTemp,
      updateProductComment: updateProductComment,
    );
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeUpdateSaleRequestTempEntity());
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(SaleRequestTempPresenterSpy());
  });

  test('Should call load products', () async {
    await sut.load(expansibleGroupId);

    verify(() => loadProducts.load(expansibleGroupId)).called(1);
  });

  test('Should throw DomainErrorUnexpected', () async {
    loadProducts.mockLoadProductsError();

    final future = sut.load(faker.randomGenerator.integer(3));

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should emit correct events on success', () async {
    loadProducts.mockLoadProducts(products);
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.productsStream.listen(expectAsync1((products) => expect(products, [
          ProductsViewModel(
            ProductsId: products[0].ProductsId,
            SaleRetailPraticed: products[0].SaleRetailPraticed,
            PriceLookupCode: products[0].PriceLookupCode,
            Name: products[0].Name,
            PackingAbbreviation: products[0].PackingAbbreviation,
            InternalCodeOnERP: products[0].InternalCodeOnERP,
            InternalCodeOfProductOnERP: products[0].InternalCodeOfProductOnERP,
            EenterpriseId: products[0].EenterpriseId,
            PackingQuantity: products[0].PackingQuantity,
            OfferRetailPrice: products[0].OfferRetailPrice,
            WholeSalePrice: products[0].WholeSalePrice,
            WholeOfferPrice: products[0].WholeOfferPrice,
            OfferECommercePrice: products[0].OfferECommercePrice,
            SaleECommercePrice: products[0].SaleECommercePrice,
            LiquidCost: products[0].LiquidCost,
            LiquidCostMiddle: products[0].LiquidCostMiddle,
            LiquidCostReal: products[0].LiquidCostReal,
            RepositionCost: products[0].RepositionCost,
            RepositionCostMiddle: products[0].RepositionCostMiddle,
            RepositionCostReal: products[0].RepositionCostReal,
            IcmsAliquot: products[0].IcmsAliquot,
            IcmsIVAMargin: products[0].IcmsIVAMargin,
            IcmsReductionMargin: products[0].IcmsReductionMargin,
            IcmsStave: products[0].IcmsStave,
            PercImpNBPTState: products[0].PercImpNBPTState,
            PercImpNBPTMunicipal: products[0].PercImpNBPTMunicipal,
            CofinsType: products[0].CofinsType,
            PisType: products[0].PisType,
            ProductIsFatherComposition: products[0].ProductIsFatherComposition,
            QuantityMinimumWholeSale: products[0].QuantityMinimumWholeSale,
            QuantityMinimumWholeSaleByClass:
                products[0].QuantityMinimumWholeSaleByClass,
            BalanceTare: products[0].BalanceTare,
            FamilyCode: products[0].FamilyCode,
            DepartmentCode: products[0].DepartmentCode,
            SectionCode: products[0].SectionCode,
            GroupCode: products[0].GroupCode,
            SubGroupCode: products[0].SubGroupCode,
            StockQuantity: products[0].StockQuantity,
            AllowFractionate: products[0].AllowFractionate,
            IsBalance: products[0].IsBalance,
            CanBeWeightyInPdv: products[0].CanBeWeightyInPdv,
            QuantityInBalance: products[0].QuantityInBalance,
            AllowQuantityInPdv: products[0].AllowQuantityInPdv,
            GoesForFastTable: products[0].GoesForFastTable,
            IsAlcoholicProduct: products[0].IsAlcoholicProduct,
            SaleRetailPrice: products[0].SaleRetailPrice,
            PercImpNBPTNational: products[0].PercImpNBPTNational,
            CofinsPercentage: products[0].CofinsPercentage,
            PisPercentage: products[0].PisPercentage,
            CFOP: products[0].CFOP,
            FiscalClassificationNCM: products[0].FiscalClassificationNCM,
            TributarySituationCode: products[0].TributarySituationCode,
            CSTPisCofins: products[0].CSTPisCofins,
            CodeClass: products[0].CodeClass,
            DepartmentName: products[0].DepartmentName,
            SectionName: products[0].SectionName,
            DateOfLastChanged: products[0].DateOfLastChanged,
            GroupName: products[0].GroupName,
            SaleRetailPraticedString: products[0].SaleRetailPraticedString,
            PersonalizedCode: products[0].PersonalizedCode,
            EanCode: products[0].EanCode,
            NameComplete: products[0].NameComplete,
            NameReduced: products[0].NameReduced,
          ),
          ProductsViewModel(
            ProductsId: products[1].ProductsId,
            SaleRetailPraticed: products[1].SaleRetailPraticed,
            PriceLookupCode: products[1].PriceLookupCode,
            Name: products[1].Name,
            PackingAbbreviation: products[1].PackingAbbreviation,
            InternalCodeOnERP: products[1].InternalCodeOnERP,
            InternalCodeOfProductOnERP: products[1].InternalCodeOfProductOnERP,
            EenterpriseId: products[1].EenterpriseId,
            PackingQuantity: products[1].PackingQuantity,
            OfferRetailPrice: products[1].OfferRetailPrice,
            WholeSalePrice: products[1].WholeSalePrice,
            WholeOfferPrice: products[1].WholeOfferPrice,
            OfferECommercePrice: products[1].OfferECommercePrice,
            SaleECommercePrice: products[1].SaleECommercePrice,
            LiquidCost: products[1].LiquidCost,
            LiquidCostMiddle: products[1].LiquidCostMiddle,
            LiquidCostReal: products[1].LiquidCostReal,
            RepositionCost: products[1].RepositionCost,
            RepositionCostMiddle: products[1].RepositionCostMiddle,
            RepositionCostReal: products[1].RepositionCostReal,
            IcmsAliquot: products[1].IcmsAliquot,
            IcmsIVAMargin: products[1].IcmsIVAMargin,
            IcmsReductionMargin: products[1].IcmsReductionMargin,
            IcmsStave: products[1].IcmsStave,
            PercImpNBPTState: products[1].PercImpNBPTState,
            PercImpNBPTMunicipal: products[1].PercImpNBPTMunicipal,
            CofinsType: products[1].CofinsType,
            PisType: products[1].PisType,
            ProductIsFatherComposition: products[1].ProductIsFatherComposition,
            QuantityMinimumWholeSale: products[1].QuantityMinimumWholeSale,
            QuantityMinimumWholeSaleByClass:
                products[1].QuantityMinimumWholeSaleByClass,
            BalanceTare: products[1].BalanceTare,
            FamilyCode: products[1].FamilyCode,
            DepartmentCode: products[1].DepartmentCode,
            SectionCode: products[1].SectionCode,
            GroupCode: products[1].GroupCode,
            SubGroupCode: products[1].SubGroupCode,
            StockQuantity: products[1].StockQuantity,
            AllowFractionate: products[1].AllowFractionate,
            IsBalance: products[1].IsBalance,
            CanBeWeightyInPdv: products[1].CanBeWeightyInPdv,
            QuantityInBalance: products[1].QuantityInBalance,
            AllowQuantityInPdv: products[1].AllowQuantityInPdv,
            GoesForFastTable: products[1].GoesForFastTable,
            IsAlcoholicProduct: products[1].IsAlcoholicProduct,
            SaleRetailPrice: products[1].SaleRetailPrice,
            PercImpNBPTNational: products[1].PercImpNBPTNational,
            CofinsPercentage: products[1].CofinsPercentage,
            PisPercentage: products[1].PisPercentage,
            CFOP: products[1].CFOP,
            FiscalClassificationNCM: products[1].FiscalClassificationNCM,
            TributarySituationCode: products[1].TributarySituationCode,
            CSTPisCofins: products[1].CSTPisCofins,
            CodeClass: products[1].CodeClass,
            DepartmentName: products[1].DepartmentName,
            SectionName: products[1].SectionName,
            DateOfLastChanged: products[1].DateOfLastChanged,
            GroupName: products[1].GroupName,
            SaleRetailPraticedString: products[1].SaleRetailPraticedString,
            PersonalizedCode: products[1].PersonalizedCode,
            EanCode: products[1].EanCode,
            NameComplete: products[1].NameComplete,
            NameReduced: products[1].NameReduced,
          ),
        ])));

    await sut.load(faker.randomGenerator.integer(3));
  });

  test('Should update indexOfSelectedProduct correctly', () async {
    sut.updateIndexOfSelectedProduct(1);
    expect(sut.indexOfSelectedProduct, 1);

    sut.updateIndexOfSelectedProduct(1);
    expect(sut.indexOfSelectedProduct, null);

    sut.updateIndexOfSelectedProduct(null);
    expect(sut.indexOfSelectedProduct, null);
  });

  test('Should call loadSaleRequestTemp when updateSaleRequestTemp', () async {
    await sut.updateSaleRequest(
      entity: EntityFactory.makeUpdateSaleRequestTempEntity(),
      expansibleGroupsPresenter: expansibleGroupsPresenter,
      comments: comments,
    );

    verify(() => loadSaleRequestTemp.load(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          enterpriseId:
              EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
          commandNumber: expansibleGroupsPresenter.commandNumberMock!,
        )).called(1);
  });

  test('Should return true on success to updateSaleRequestTemp', () async {
    final isUpdated = await sut.updateSaleRequest(
      entity: EntityFactory.makeUpdateSaleRequestTempEntity(),
      expansibleGroupsPresenter: expansibleGroupsPresenter,
      comments: comments,
    );

    expect(isUpdated, true);
  });

  test('Should throw Unexpected error when updateSaleRequest throws', () async {
    updateSaleRequestTemp.mockUpdateSaleRequestTempError();

    final error = sut.updateSaleRequest(
      entity: EntityFactory.makeUpdateSaleRequestTempEntity(),
      expansibleGroupsPresenter: expansibleGroupsPresenter,
      comments: comments,
    );

    expect(error, throwsA(DomainError.unexpected));
  });

  test('Should throw Unexpected error when loadSaleRequestTemp throws',
      () async {
    loadSaleRequestTemp.mockError();

    final error = sut.updateSaleRequest(
      entity: EntityFactory.makeUpdateSaleRequestTempEntity(),
      expansibleGroupsPresenter: expansibleGroupsPresenter,
      comments: comments,
    );

    expect(error, throwsA(DomainError.unexpected));
  });
}
