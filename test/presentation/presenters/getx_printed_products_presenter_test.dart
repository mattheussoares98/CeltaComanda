import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:faker/faker.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';
import '../../ui/mocks/mocks.dart';

void main() {
  late GetxPrintedProductsPresenter sut;
  late SaleRequestTempPresenterSpy saleRequestTempPresenter;
  late ExpansibleGroupsPresenterSpy expansibleGroupsPresenter;
  late HomePresenterSpy homePresenter;

  late UserValidationsSpy userValidations;
  late LoadPrintedProductsSpy loadPrintedProducts;
  late RemovePrintedProductSpy removePrintedProduct;
  late FinishSaleRequestTempSpy finishSaleRequestTemp;

  late PrintedEntity printedEntity;
  late SaleRequestTempEntity saleRequestTempEntity;

  late int personalizedCode;
  late String password;
  late String saleRequestProductId;

  void initPresenters() {
    saleRequestTempPresenter = SaleRequestTempPresenterSpy();
    expansibleGroupsPresenter = ExpansibleGroupsPresenterSpy();
    homePresenter = HomePresenterSpy();

    sut = GetxPrintedProductsPresenter(
      userValidations: userValidations,
      loadPrintedProducts: loadPrintedProducts,
      removePrintedProduct: removePrintedProduct,
    );
  }

  void initUsecases() {
    userValidations = UserValidationsSpy();
    loadPrintedProducts = LoadPrintedProductsSpy();
    removePrintedProduct = RemovePrintedProductSpy();
    finishSaleRequestTemp = FinishSaleRequestTempSpy();
  }

  void initEntitys() {
    personalizedCode = faker.randomGenerator.integer(5);
    password = faker.randomGenerator.string(5);
    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();
    printedEntity = EntityFactory.makePrintedProductsEntity();
    saleRequestProductId = faker.randomGenerator.integer(5).toString();
    homePresenter.commandNumberMock =
        faker.randomGenerator.integer(3).toString();
    loadPrintedProducts.mockLoadPrintedProducts(printedEntity);
    homePresenter.commandNumberMock =
        faker.randomGenerator.integer(3).toString();
    saleRequestTempEntity = EntityFactory.makeSaleRequestTempEntity();
    saleRequestTempPresenter.saleRequestTempMock =
        SaleRequestTempViewModel.fromEntity(saleRequestTempEntity);
  }

  void mockSuccess() {
    finishSaleRequestTemp.mockFinishSaleRequestTemp();
  }

  setUp(() {
    initUsecases();
    initPresenters();
    initEntitys();
    mockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(SaleRequestTempPresenterSpy());
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(ExpansibleGroupsPresenterSpy());
    registerFallbackValue(EntityFactory.makeSaleRequestTempEntity());
  });

  group("Validate password", () {
    test('Should call isValidPassword with correct values', () async {
      await sut.removeProduct(
        saleRequestProductId: saleRequestProductId,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
        printedProductsPresenter: sut,
        saleRequestTempPresenter: saleRequestTempPresenter,
        homePresenter: homePresenter,
      );

      verify(
        () => userValidations.isValidPassword(
          password: password,
          personalizedCode: personalizedCode,
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        ),
      ).called(1);
    });

    test('Should return true on password is valid', () async {
      userValidations.mockIsValidPassword(true);

      final validPassword = await userValidations.isValidPassword(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        password: password,
        personalizedCode: personalizedCode,
      );

      expect(validPassword, true);
    });

    test('Should show invalidCredentials UIError on invalid credential',
        () async {
      userValidations.mockIsValidPasswordError(DomainError.invalidCredentials);

      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.invalidCredentials]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.removeProduct(
        saleRequestProductId: saleRequestProductId,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
        printedProductsPresenter: sut,
        saleRequestTempPresenter: saleRequestTempPresenter,
        homePresenter: homePresenter,
      );
    });

    test('Should show accessDenied UIError on user dont have permission',
        () async {
      userValidations.mockIsValidPasswordError(DomainError.unexpected);

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.removeProduct(
        saleRequestProductId: saleRequestProductId,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
        printedProductsPresenter: sut,
        saleRequestTempPresenter: saleRequestTempPresenter,
        homePresenter: homePresenter,
      );
    });
  });
  group("Verify user can cancel", () {
    test('Should emit correct values on success canCancel', () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.removeProduct(
        saleRequestProductId: saleRequestProductId,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
        printedProductsPresenter: sut,
        saleRequestTempPresenter: saleRequestTempPresenter,
        homePresenter: homePresenter,
      );
    });
    test('Should call userCanCancel with correct values', () async {
      await sut.removeProduct(
        saleRequestProductId: saleRequestProductId,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
        printedProductsPresenter: sut,
        saleRequestTempPresenter: saleRequestTempPresenter,
        homePresenter: homePresenter,
      );

      verify(
        () => userValidations.canCancel(
          personalizedCode: personalizedCode,
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        ),
      ).called(1);
    });

    test('Should return true on user can cancel', () async {
      final canCancel = await userValidations.canCancel(
        personalizedCode: personalizedCode,
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
      );

      expect(canCancel, true);
    });

    test('Should show accessDeniedError if user dont have permission',
        () async {
      userValidations.mockCanCancelError(DomainError.accessDenied);

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.accessDenied]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.removeProduct(
        saleRequestProductId: saleRequestProductId,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
        printedProductsPresenter: sut,
        saleRequestTempPresenter: saleRequestTempPresenter,
        homePresenter: homePresenter,
      );
    });

    test('Should show unexpected UIError on unexpected error', () async {
      userValidations.mockCanCancelError(DomainError.unexpected);

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.removeProduct(
        saleRequestProductId: saleRequestProductId,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
        printedProductsPresenter: sut,
        saleRequestTempPresenter: saleRequestTempPresenter,
        homePresenter: homePresenter,
      );
    });
  });

  group("Manipulate data", () {
    test('Should emit correct values on success loadData', () async {
      expectLater(sut.mainErrorStream, emits(null));

      await sut.load(homePresenter.commandNumberMock!);
    });
    test('Should emit correct values on error to loadData', () async {
      loadPrintedProducts.mockError();
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.load(homePresenter.commandNumberMock!);
    });
    test("Should call loadPrintedProducts with correct values", () async {
      await sut.load(homePresenter.commandNumberMock!);

      verify(() => loadPrintedProducts.load(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            enterpriseId:
                EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
            commandNumber: int.parse(homePresenter.commandNumberMock!),
          )).called(1);
    });

    test("Should return correct printedProducts on LoadPrintedProducts",
        () async {
      final result = await loadPrintedProducts.load(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        commandNumber: int.parse(homePresenter.commandNumberMock!),
      );

      expect(result, printedEntity);
    });

    test("Should return null on loadPrintedProducts", () async {
      loadPrintedProducts.mockLoadPrintedProducts(null);
      final result = await loadPrintedProducts.load(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        commandNumber: int.parse(homePresenter.commandNumberMock!),
      );

      expect(result, null);
    });

    test("Should emit correct events", () async {
      loadPrintedProducts.mockError();

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.load(homePresenter.commandNumberMock!);
    });

    test("Should clear printed on call clearPrinted", () async {
      await sut.load(homePresenter.commandNumberMock!);
      sut.clear();

      expect(sut.printedProducts, null);
    });

    test("ShouldCall HomePresenter.load on removeProduct success to data",
        () async {
      await sut.removeProduct(
        saleRequestProductId: saleRequestProductId,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        printedProductsPresenter: sut,
        homePresenter: homePresenter,
      );

      verify(() => homePresenter.load(
            commandNumber: homePresenter.commandNumberMock!,
            printedProductsPresenter: sut,
            saleRequestTempPresenter: saleRequestTempPresenter,
            expansibleGroupsPresenter: expansibleGroupsPresenter,
          )).called(1);
    });
    test("ShouldCall removeProduct on call sut.removeProduct", () async {
      await sut.removeProduct(
        saleRequestProductId: saleRequestProductId,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        printedProductsPresenter: sut,
        homePresenter: homePresenter,
      );

      verify(() => removePrintedProduct.remove(
            productId: saleRequestProductId,
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          )).called(1);
    });

    test("Should not update printedProducts if the list of products is empty",
        () async {
      loadPrintedProducts.mockLoadPrintedProducts(PrintedEntity(
        Products: [],
        PersonalizedCode: faker.randomGenerator.string(10),
        DateOfCreation: faker.randomGenerator.string(10),
        DateHourOfCreation: faker.randomGenerator.string(10),
        FlagStatus: faker.randomGenerator.string(10),
        EnterpriseId: faker.randomGenerator.integer(10),
        RequestType: faker.randomGenerator.string(10),
        IsCancelled: faker.randomGenerator.boolean(),
        IsUsing: faker.randomGenerator.boolean(),
        TotalLiquid: faker.randomGenerator.decimal(),
        Peoples: faker.randomGenerator.integer(10),
        SaleRequestId: faker.randomGenerator.integer(10),
        FlagOrigin: faker.randomGenerator.integer(10),
        DeliveryControl: faker.randomGenerator.integer(10),
      ));

      await sut.load(homePresenter.commandNumberMock!);

      expect(sut.printedProducts, null);
    });
  });
}
