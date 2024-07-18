import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
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
  late CartPresenterSpy cartPresenter;
  late HomePresenterSpy homePresenter;

  late List<ProductEntity> products;
  late int expansibleGroupId;
  late SaleRequestTempEntity saleRequestTempEntity;
  late ProductsViewModel productsViewModel;
  late UpdateSaleRequestTempEntity updateSaleRequestTempEntity;

  late NavigateToSpy navigateTo;
  late LoadProductsSpy loadProducts;
  late UpdateSaleRequestTempSpy updateSaleRequestTemp;
  late LoadSaleRequestTempSpy loadSaleRequestTemp;

  void initPresenters() {
    cartPresenter = CartPresenterSpy();
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
    saleRequestTempEntity = EntityFactory.makeSaleRequestTempEntity(0);
    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();
    homePresenter.commandNumberMock =
        faker.randomGenerator.integer(3).toString();
    productsViewModel =
        ProductsViewModel.fromEntity(saleRequestTempEntity.Products[0].Product);
    cartPresenter.saleRequestTempMock =
        SaleRequestTempViewModel.fromEntity(saleRequestTempEntity);
    updateSaleRequestTempEntity =
        EntityFactory.makeUpdateSaleRequestTempEntity();
  }

  void mockSuccess() {
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
    registerFallbackValue(EntityFactory.makeProductViewModel());
    registerFallbackValue(CommentsPresenterSpy());
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(CartPresenterSpy());
    registerFallbackValue(MenuPresenterSpy());
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
        cartPresenter: cartPresenter,
        products: updateSaleRequestTempEntity.Products,
      );

      verify(() =>
              cartPresenter.loadSaleRequest(homePresenter.commandNumberMock!))
          .called(1);
    });

    test(
        "Should emit CommandNotAvailable commandNotAvailable on cartPresenter.loadSaleRequest throws CommandNotAvailable",
        () async {
      cartPresenter
          .mockLoadSaleRequestTempError(DomainError.commandNotAvailable);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.commandNotAvailable]));

      await sut.updateSaleRequest(
        productsViewModel: productsViewModel,
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        products: updateSaleRequestTempEntity.Products,
      );
    });

    test('Should emit UnexpectedError on error to loadSaleRequestTemp',
        () async {
      cartPresenter.mockLoadSaleRequestTempError(DomainError.unexpected);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.updateSaleRequest(
        productsViewModel: productsViewModel,
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        products: updateSaleRequestTempEntity.Products,
      );
    });

    test('Should emit correct events on loadSaleRequestTemp success', () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.updateSaleRequest(
        productsViewModel: productsViewModel,
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        products: updateSaleRequestTempEntity.Products,
      );
    });
  });

  group("LoadProducts", () {
    test('Should call load products', () async {
      await sut.load(expansibleGroupId);

      verify(() => loadProducts.load(expansibleGroupId)).called(1);
    });

    test('Should emit correct events on error to load', () async {
      loadProducts.mockLoadProductsError(DomainError.unexpected);
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.load(faker.randomGenerator.integer(3));
    });
  });

  group("UpdateSaleRequest", () {
    test('Should emit correct events on UpdateSaleRequest success', () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.updateSaleRequest(
        productsViewModel: productsViewModel,
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        products: updateSaleRequestTempEntity.Products,
      );
    });

    test('Should emit correct events on UpdateSaleRequest throws unexpected',
        () async {
      updateSaleRequestTemp
          .mockUpdateSaleRequestTempError(DomainError.unexpected);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.updateSaleRequest(
        productsViewModel: productsViewModel,
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        products: updateSaleRequestTempEntity.Products,
      );
    });

    test(
        'Should emit correct events on UpdateSaleRequest throws commandNotAvailable',
        () async {
      updateSaleRequestTemp
          .mockUpdateSaleRequestTempError(DomainError.commandNotAvailable);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.commandNotAvailable]));

      await sut.updateSaleRequest(
        productsViewModel: productsViewModel,
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        products: updateSaleRequestTempEntity.Products,
      );
    });

    test('Should call updateSaleRequestTemp with correct entity', () async {
      await sut.updateSaleRequest(
        productsViewModel: productsViewModel,
        homePresenter: homePresenter,
        cartPresenter: cartPresenter,
        products: updateSaleRequestTempEntity.Products,
      );

      final entity = UpdateSaleRequestTempEntity(
        DeliveryControl:
            int.parse(cartPresenter.saleRequestTempMock!.DeliveryControl),
        EnterpriseId:
            int.parse(cartPresenter.saleRequestTempMock!.EnterpriseId),
        PersonalizedCode: cartPresenter.saleRequestTempMock!.PersonalizedCode,
        SaleRequestTempId:
            int.parse(cartPresenter.saleRequestTempMock!.SaleRequestTempId),
        TotalLiquid: updateSaleRequestTempEntity.Products.fold(0.0,
            (previousValue, element) => element.TotalLiquid + previousValue),
        Products: updateSaleRequestTempEntity.Products,
      );

      verify(() => updateSaleRequestTemp.update(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            entity: entity,
          )).called(1);
    });
  });

  test('Should call CartPresenter.load', () async {
    await sut.updateSaleRequest(
      productsViewModel: productsViewModel,
      homePresenter: homePresenter,
      cartPresenter: cartPresenter,
      products: updateSaleRequestTempEntity.Products,
    );

    verify(() =>
            cartPresenter.loadSaleRequest(homePresenter.commandNumberMock!))
        .called(1);
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
