import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
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
  late SaleRequestTempPresenterSpy saleRequestTempPresenter;
  late HomePresenterSpy homePresenter;

  late List<ProductEntity> products;
  late int expansibleGroupId;
  late SaleRequestTempEntity saleRequestTempEntity;
  late ProductsViewModel productsViewModel;
  late String productComment;

  late NavigateToSpy navigateTo;
  late LoadProductsSpy loadProducts;
  late UpdateSaleRequestTempSpy updateSaleRequestTemp;
  late LoadSaleRequestTempSpy loadSaleRequestTemp;

  void initPresenters() {
    saleRequestTempPresenter = SaleRequestTempPresenterSpy();
    homePresenter = HomePresenterSpy();
    sut = GetxProductsPresenter(
      navigateTo: navigateTo,
      loadProducts: loadProducts,
      updateSaleRequestTemp: updateSaleRequestTemp,
    );
  }

  void initUsecases() {
    loadProducts = LoadProductsSpy();
    navigateTo = NavigateToSpy();
    updateSaleRequestTemp = UpdateSaleRequestTempSpy();
    loadSaleRequestTemp = LoadSaleRequestTempSpy();
  }

  void initEntitys() {
    expansibleGroupId = faker.randomGenerator.integer(3);
    products = EntityFactory.makeProductsEntitys();
    saleRequestTempEntity = EntityFactory.makeSaleRequestTempEntity();
    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();
    homePresenter.commandNumberMock =
        faker.randomGenerator.integer(3).toString();
    productsViewModel =
        ProductsViewModel.fromEntity(saleRequestTempEntity.Products[0].Product);
    saleRequestTempPresenter.saleRequestTempMock =
        SaleRequestTempViewModel.fromEntity(saleRequestTempEntity);
    productComment = faker.randomGenerator.string(10);
  }

  void mockSuccess() {
    navigateTo.mockNavigate();
    loadProducts.mockLoadProducts(products);
    updateSaleRequestTemp.mockUpdateSaleRequestTemp();
    loadSaleRequestTemp.mockLoadSaleRequestTemp(saleRequestTempEntity);
  }

  setUp(() {
    initUsecases();
    initPresenters();
    initEntitys();
    mockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeUpdateSaleRequestTempEntity());
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(SaleRequestTempPresenterSpy());
    registerFallbackValue(ExpansibleGroupsPresenterSpy());
  });

  group("LoadSaleRequestTemp", () {
    test('Should return correct entity on success to loadSaleRequestTemp',
        () async {
      final value = await loadSaleRequestTemp.load(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        commandNumber: homePresenter.commandNumberMock!,
      );

      expect(value, saleRequestTempEntity);
    });

    test('Should call loadSaleRequestTemp when updateSaleRequestTemp',
        () async {
      await sut.updateSaleRequest(
        productsViewModel: productsViewModel,
        homePresenter: homePresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        productComment: productComment,
      );

      verify(() => saleRequestTempPresenter
          .loadSaleRequest(homePresenter.commandNumberMock!)).called(1);
    });

    test('Should emit UnexpectedError on error to loadSaleRequestTemp',
        () async {
      saleRequestTempPresenter.mockLoadSaleRequestTempError();

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.updateSaleRequest(
        productsViewModel: productsViewModel,
        homePresenter: homePresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        productComment: productComment,
      );
    });

    test('Should emit correct events on loadSaleRequestTemp success', () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.updateSaleRequest(
        productsViewModel: productsViewModel,
        homePresenter: homePresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        productComment: productComment,
      );
    });
  });

  group("LoadProducts", () {
    test('Should call load products', () async {
      await sut.load(expansibleGroupId);

      verify(() => loadProducts.load(expansibleGroupId)).called(1);
    });

    test('Should emit correct events on success to load', () async {
      loadProducts.mockLoadProducts(products);
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));
      sut.productsStream.listen(expectAsync1((products) => expect(products, [
            ProductsViewModel.fromEntity(products[0].toEntity()),
            ProductsViewModel.fromEntity(products[1].toEntity()),
          ])));

      await sut.load(faker.randomGenerator.integer(3));
    });

    test('Should emit correct events on error to load', () async {
      loadProducts.mockLoadProductsError();
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.load(faker.randomGenerator.integer(3));
    });
  });

  group("UpdateSaleRequest", () {
    test('Should return true on success to updateSaleRequestTemp', () async {
      final isUpdated = await sut.updateSaleRequest(
        productsViewModel: productsViewModel,
        homePresenter: homePresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        productComment: productComment,
      );

      expect(isUpdated, true);
    });
    test('Should return false on error to updateSaleRequestTemp', () async {
      updateSaleRequestTemp.mockUpdateSaleRequestTempError();

      final isUpdated = await sut.updateSaleRequest(
        productsViewModel: productsViewModel,
        homePresenter: homePresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        productComment: productComment,
      );

      expect(isUpdated, false);
    });

    test('Should emit correct events on UpdateSaleRequest success', () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.updateSaleRequest(
        productsViewModel: productsViewModel,
        homePresenter: homePresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        productComment: productComment,
      );
    });

    test('Should emit correct events on error to UpdateSaleRequest', () async {
      updateSaleRequestTemp.mockUpdateSaleRequestTempError();

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.updateSaleRequest(
        productsViewModel: productsViewModel,
        homePresenter: homePresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        productComment: productComment,
      );
    });

    test('Should call updateSaleRequestTemp', () async {
      await sut.updateSaleRequest(
        productsViewModel: productsViewModel,
        homePresenter: homePresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        productComment: productComment,
      );

      double saleRetailPraticed =
          productsViewModel.SaleRetailPraticed.toDouble();

      final entity = UpdateSaleRequestTempEntity(
        DeliveryControl: int.parse(
            saleRequestTempPresenter.saleRequestTempMock!.DeliveryControl),
        EnterpriseId: int.parse(
            saleRequestTempPresenter.saleRequestTempMock!.EnterpriseId),
        PersonalizedCode:
            saleRequestTempPresenter.saleRequestTempMock!.PersonalizedCode,
        SaleRequestTempId: int.parse(
            saleRequestTempPresenter.saleRequestTempMock!.SaleRequestTempId),
        TotalLiquid: saleRetailPraticed,
        Products: [
          UpdateSaleRequestTempProductEntity(
            ProductInternalCodeOnErp:
                int.parse(productsViewModel.InternalCodeOnERP.toString()),
            ProductPriceLookUpCode: productsViewModel.PriceLookupCode,
            Quantity: 1,
            SaleRequestTempId: int.parse(saleRequestTempPresenter
                .saleRequestTempMock!.SaleRequestTempId),
            TotalLiquid: saleRetailPraticed,
            Value: saleRetailPraticed,
            Comments: productComment,
          )
        ],
      );

      verify(() => updateSaleRequestTemp.update(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            entity: entity,
          )).called(1);
    });
    test('Should call updateSaleRequestTemp with null comment if comment is empty', () async {
      await sut.updateSaleRequest(
        productsViewModel: productsViewModel,
        homePresenter: homePresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        productComment: "",
      );

      double saleRetailPraticed =
          productsViewModel.SaleRetailPraticed.toDouble();

      final entity = UpdateSaleRequestTempEntity(
        DeliveryControl: int.parse(
            saleRequestTempPresenter.saleRequestTempMock!.DeliveryControl),
        EnterpriseId: int.parse(
            saleRequestTempPresenter.saleRequestTempMock!.EnterpriseId),
        PersonalizedCode:
            saleRequestTempPresenter.saleRequestTempMock!.PersonalizedCode,
        SaleRequestTempId: int.parse(
            saleRequestTempPresenter.saleRequestTempMock!.SaleRequestTempId),
        TotalLiquid: saleRetailPraticed,
        Products: [
          UpdateSaleRequestTempProductEntity(
            ProductInternalCodeOnErp:
                int.parse(productsViewModel.InternalCodeOnERP.toString()),
            ProductPriceLookUpCode: productsViewModel.PriceLookupCode,
            Quantity: 1,
            SaleRequestTempId: int.parse(saleRequestTempPresenter
                .saleRequestTempMock!.SaleRequestTempId),
            TotalLiquid: saleRetailPraticed,
            Value: saleRetailPraticed,
            Comments: null,
          )
        ],
      );

      verify(() => updateSaleRequestTemp.update(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            entity: entity,
          )).called(1);
    });
  });

  test('Should call SaleRequestTempPresenter.load', () async {
    await sut.updateSaleRequest(
      productsViewModel: productsViewModel,
      homePresenter: homePresenter,
      saleRequestTempPresenter: saleRequestTempPresenter,
      productComment: productComment,
    );

    verify(() => saleRequestTempPresenter
        .loadSaleRequest(homePresenter.commandNumberMock!)).called(1);
  });

  test('Should go to ComboxPage', () async {
    sut.goToComboxPage(productsViewModel);

    verify(
      () => navigateTo.navigate(
        pageRoute: PageRoutes.productComposition,
        arguments: productsViewModel,
      ),
    ).called(1);
  });
}
