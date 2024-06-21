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
  late CartPresenterSpy cartPresenter;
  late MenuPresenterSpy menuPresenter;
  late HomePresenterSpy homePresenter;

  late UserValidationsSpy userValidations;
  late LoadPrintedProductsSpy loadPrintedProducts;
  late RemovePrintedProductSpy removePrintedProduct;
  late FinishSaleRequestTempSpy finishSaleRequestTemp;
  late TicketIsPermittedSpy ticketIsPermitted;
  late BarcodeScannerSpy barcodeScanner;

  late PrintedEntity printedEntity;
  late SaleRequestTempEntity saleRequestTempEntity;

  late int personalizedCode;
  late String password;
  late String saleRequestProductId;

  void initPresenters() {
    cartPresenter = CartPresenterSpy();
    menuPresenter = MenuPresenterSpy();
    homePresenter = HomePresenterSpy();

    sut = GetxPrintedProductsPresenter(
      userValidations: userValidations,
      loadPrintedProducts: loadPrintedProducts,
      removePrintedProduct: removePrintedProduct,
      ticketIsPermitted: ticketIsPermitted,
      barcodeScanner: barcodeScanner,
    );
  }

  void initUsecases() {
    userValidations = UserValidationsSpy();
    loadPrintedProducts = LoadPrintedProductsSpy();
    removePrintedProduct = RemovePrintedProductSpy();
    finishSaleRequestTemp = FinishSaleRequestTempSpy();
    ticketIsPermitted = TicketIsPermittedSpy();
    barcodeScanner = BarcodeScannerSpy();
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
    saleRequestTempEntity = EntityFactory.makeSaleRequestTempEntity(0);
    cartPresenter.saleRequestTempMock =
        SaleRequestTempViewModel.fromEntity(saleRequestTempEntity);
  }

  void mockSuccess() {
    finishSaleRequestTemp.mockFinishSaleRequestTemp();
    userValidations.mockIsValidPassword(true);
    userValidations.mockCanCancel(true);
    loadPrintedProducts.mockLoadPrintedProducts(printedEntity);
    barcodeScanner.mockBarcodeScanner(homePresenter.commandNumberMock!);
  }

  setUp(() {
    initUsecases();
    initPresenters();
    initEntitys();
    mockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeSaleRequestTempEntity(0));
    registerFallbackValue(EntityFactory.makeProductViewModel());
    registerFallbackValue(CartPresenterSpy());
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(MenuPresenterSpy());
  });

  group("Validate password", () {
    test('Should call isValidPassword with correct values', () async {
      await sut.validateUserAndPermissionToCancelProducts(
        personalizedCode: personalizedCode,
        password: password,
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
      final validPassword = await userValidations.isValidPassword(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        password: password,
        personalizedCode: personalizedCode,
      );

      expect(validPassword, true);
    });

    test('Should return false on password is invalid', () async {
      userValidations.mockIsValidPassword(false);

      final validPassword = await userValidations.isValidPassword(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        password: password,
        personalizedCode: personalizedCode,
      );

      expect(validPassword, false);
    });

    test('Should emit correct values on success isValidPassword', () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.alertMessageStream,
          emitsInOrder([null, R.string.msgSuccessToCancelProducts]));

      await sut.validateUserAndPermissionToCancelProducts(
        personalizedCode: personalizedCode,
        password: password,
      );

      expect(sut.canCancelProducts, true);
    });

    test('Should show invalidCredentials UIError on invalid credentials',
        () async {
      userValidations.mockIsValidPassword(false);

      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.invalidCredentials]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.alertMessageStream, emits(null));

      await sut.validateUserAndPermissionToCancelProducts(
        personalizedCode: personalizedCode,
        password: password,
      );

      expect(sut.canCancelProducts, false);
    });

    test('Should emit correct values on validateUserCanCancel throws',
        () async {
      userValidations.mockCanCancelError(DomainError.unexpected);

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.alertMessageStream, emits(null));

      await sut.validateUserAndPermissionToCancelProducts(
        personalizedCode: personalizedCode,
        password: password,
      );

      expect(sut.canCancelProducts, false);
    });

    test('Should emit correct values on password is invalid', () async {
      userValidations.mockIsValidPassword(false);

      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.invalidCredentials]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.alertMessageStream, emits(null));

      await sut.validateUserAndPermissionToCancelProducts(
        personalizedCode: personalizedCode,
        password: password,
      );

      expect(sut.canCancelProducts, false);
    });

    test('Should canCancelProducts is true if userValidations return true',
        () async {
      await sut.validateUserAndPermissionToCancelProducts(
        personalizedCode: personalizedCode,
        password: password,
      );

      expect(sut.canCancelProducts, true);
    });

    test(
        'Should show invalidCredentialsOrAccessDenied UIError on error to validate password',
        () async {
      userValidations.mockIsValidPasswordError(
          DomainError.invalidCredentialsOrAccessDenied);

      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.invalidCredentialsOrAccessDenied]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.validateUserAndPermissionToCancelProducts(
        personalizedCode: personalizedCode,
        password: password,
      );
    });

    test('Should show unexpected UIError on error to validate password',
        () async {
      userValidations.mockIsValidPasswordError(DomainError.unexpected);

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.validateUserAndPermissionToCancelProducts(
        personalizedCode: personalizedCode,
        password: password,
      );
    });
  });
  group("Verify user can cancel", () {
    test('Should call userCanCancel with correct values', () async {
      await sut.validateUserAndPermissionToCancelProducts(
        personalizedCode: personalizedCode,
        password: password,
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

    test('Should return false on user cant cancel', () async {
      userValidations.mockCanCancel(false);

      final canCancel = await userValidations.canCancel(
        personalizedCode: personalizedCode,
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
      );

      expect(canCancel, false);
    });

    test('Should emit correct values on success canCancel', () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.alertMessageStream,
          emitsInOrder([null, R.string.msgSuccessToCancelProducts]));

      await sut.validateUserAndPermissionToCancelProducts(
        personalizedCode: personalizedCode,
        password: password,
      );

      expect(sut.canCancelProducts, true);
    });

    test('Should emit correct values on user cant cancel', () async {
      userValidations.mockCanCancel(false);

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.accessDenied]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.alertMessageStream, emits(null));

      await sut.validateUserAndPermissionToCancelProducts(
        personalizedCode: personalizedCode,
        password: password,
      );

      expect(sut.canCancelProducts, false);
    });

    test('Should emit correct values on validateUserCanCancel throws',
        () async {
      userValidations.mockCanCancelError(DomainError.unexpected);

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.alertMessageStream, emits(null));

      await sut.validateUserAndPermissionToCancelProducts(
        personalizedCode: personalizedCode,
        password: password,
      );

      expect(sut.canCancelProducts, false);
    });
  });

  group("Manipulate data", () {
    test('Should update printedProducts correctly on loadPrinted success',
        () async {
      await sut.loadPrinted(homePresenter.commandNumberMock!);

      expect(sut.printedProducts, PrintedViewModel.fromEntity(printedEntity));
    });

    test("Should call loadPrintedProducts with correct values", () async {
      await sut.loadPrinted(homePresenter.commandNumberMock!);

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

    test("Should emit correct events on loadPrintedProducts throws", () async {
      loadPrintedProducts.mockError(DomainError.unexpected);

      final error = sut.loadPrinted(homePresenter.commandNumberMock!);

      expect(error, throwsA(DomainError.unexpected));
    });

    test("Should emit correct events on ticket is not permitted", () async {
      loadPrintedProducts.mockError(DomainError.commandNotAvailable);

      final error = sut.loadPrinted(homePresenter.commandNumberMock!);

      expect(error, throwsA(DomainError.commandNotAvailable));
    });

    test("Should clear printed on call clearPrinted", () async {
      await sut.loadPrinted(homePresenter.commandNumberMock!);
      sut.clear();

      expect(sut.printedProducts, null);
    });

    test(
        "ShouldCall LoadCommandData on removeProduct success and dont update permission to cancel products",
        () async {
      sut.updateCanCancelProducts(true);

      await sut.removeProduct(
        saleRequestProductId: saleRequestProductId,
        menuPresenter: menuPresenter,
        cartPresenter: cartPresenter,
        printedProductsPresenter: sut,
        homePresenter: homePresenter,
      );

      verifyNever(() =>
          homePresenter.updateCommandNumber(homePresenter.commandNumberMock!));
      verifyNever(() => menuPresenter.clear());
      verifyNever(() =>
          menuPresenter.getGroupsAndProducts(homePresenter.commandNumberMock!));

      verify(() => cartPresenter.clear()).called(1);
      verify(() =>
              cartPresenter.loadSaleRequest(homePresenter.commandNumberMock!))
          .called(1);
      expect(sut.printedProducts, PrintedViewModel.fromEntity(printedEntity));
      expect(sut.canCancelProducts, true);
    });
    test("ShouldCall removeProduct on call sut.removeProduct", () async {
      await sut.removeProduct(
        saleRequestProductId: saleRequestProductId,
        menuPresenter: menuPresenter,
        cartPresenter: cartPresenter,
        printedProductsPresenter: sut,
        homePresenter: homePresenter,
      );

      verify(() => removePrintedProduct.remove(
            productId: saleRequestProductId,
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          )).called(1);
    });

    test("Should emit correct values on removeProduct success", () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.removeProduct(
        saleRequestProductId: saleRequestProductId,
        menuPresenter: menuPresenter,
        cartPresenter: cartPresenter,
        printedProductsPresenter: sut,
        homePresenter: homePresenter,
      );
    });

    test("Should emit correct values on removeProduct throws", () async {
      removePrintedProduct.mockError(DomainError.unexpected);
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.removeProduct(
        saleRequestProductId: saleRequestProductId,
        menuPresenter: menuPresenter,
        cartPresenter: cartPresenter,
        printedProductsPresenter: sut,
        homePresenter: homePresenter,
      );
    });

    test("Should emit correct values on removeProduct throws", () async {
      removePrintedProduct.mockError(DomainError.unexpected);
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.removeProduct(
        saleRequestProductId: saleRequestProductId,
        menuPresenter: menuPresenter,
        cartPresenter: cartPresenter,
        printedProductsPresenter: sut,
        homePresenter: homePresenter,
      );
    });

    test("Should emit correct values on ticket is not permitted", () async {
      ticketIsPermitted.mockError();
      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.commandNotAvailable]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.removeProduct(
        saleRequestProductId: saleRequestProductId,
        menuPresenter: menuPresenter,
        cartPresenter: cartPresenter,
        printedProductsPresenter: sut,
        homePresenter: homePresenter,
      );
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

      await sut.loadPrinted(homePresenter.commandNumberMock!);

      expect(sut.printedProducts, null);
    });
  });

  group("Load commandData", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.loadCommandData(
        printedProductsPresenter: sut,
        cartPresenter: cartPresenter,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
        clearPermissionToCancelProducts: true,
        isRemovingProduct: false,
        isGeneratingVersionToRede: cartPresenter.isGeneratingVersionToRede,
        commandNumber: homePresenter.commandNumberMock!,
      );
    });

    test(
        "Should emit correct values on loadCommandData throws commandNotAvailable",
        () async {
      ticketIsPermitted.mockError();

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.commandNotAvailable]));

      await sut.loadCommandData(
        printedProductsPresenter: sut,
        cartPresenter: cartPresenter,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
        clearPermissionToCancelProducts: true,
        isRemovingProduct: false,
        isGeneratingVersionToRede: cartPresenter.isGeneratingVersionToRede,
        commandNumber: homePresenter.commandNumberMock!,
      );
    });

    test("Should emit correct values on loadCommandData throws barcodeNotRead",
        () async {
      barcodeScanner.mockError(DomainError.barcodeNotRead);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.barcodeNotRead]));

      await sut.loadCommandData(
        printedProductsPresenter: sut,
        cartPresenter: cartPresenter,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
        clearPermissionToCancelProducts: true,
        isRemovingProduct: false,
        isGeneratingVersionToRede: cartPresenter.isGeneratingVersionToRede,
        commandNumber: homePresenter.commandNumberMock!,
      );
    });
    test("Should emit correct values on loadCommandData throws unexpected",
        () async {
      barcodeScanner.mockError(DomainError.unexpected);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.loadCommandData(
        printedProductsPresenter: sut,
        cartPresenter: cartPresenter,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
        clearPermissionToCancelProducts: true,
        isRemovingProduct: false,
        isGeneratingVersionToRede: cartPresenter.isGeneratingVersionToRede,
        commandNumber: homePresenter.commandNumberMock!,
      );
    });

    test("Should update commandNumber", () async {
      homePresenter.commandNumberMock = "9999";

      await sut.loadCommandData(
        printedProductsPresenter: sut,
        cartPresenter: cartPresenter,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
        clearPermissionToCancelProducts: true,
        isRemovingProduct: false,
        isGeneratingVersionToRede: cartPresenter.isGeneratingVersionToRede,
        commandNumber: homePresenter.commandNumberMock!,
      );

      expect(homePresenter.commandNumberMock, "9999");
    });

    test("Should call clearData on LoadCommandData call", () async {
      await sut.loadCommandData(
        printedProductsPresenter: sut,
        cartPresenter: cartPresenter,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
        clearPermissionToCancelProducts: true,
        isRemovingProduct: false,
        isGeneratingVersionToRede: cartPresenter.isGeneratingVersionToRede,
        commandNumber: homePresenter.commandNumberMock!,
      );

      expect(sut.printedProducts, PrintedViewModel.fromEntity(printedEntity));

      loadPrintedProducts.mockError(DomainError.unexpected);

      await sut.loadCommandData(
        printedProductsPresenter: sut,
        cartPresenter: cartPresenter,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
        clearPermissionToCancelProducts: true,
        isRemovingProduct: false,
        isGeneratingVersionToRede: cartPresenter.isGeneratingVersionToRede,
        commandNumber: homePresenter.commandNumberMock!,
      );

      expect(sut.printedProducts, null);
      verify(() => menuPresenter.clear()).called(2);
      verify(() => cartPresenter.clear()).called(2);
      //como o sut não é mockado, fiz um teste primeiro com sucesso pra ter
      //certeza que vai colocar dados no expansibleGroups e outro teste com
      //erro, pra ter certeza que vai chamar a função para limpar a lista de
      //grupos expansíveis
    });

    test("Should call ticketIsPermitted only one time", () async {
      await sut.loadCommandData(
        printedProductsPresenter: sut,
        cartPresenter: cartPresenter,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
        clearPermissionToCancelProducts: true,
        isRemovingProduct: false,
        isGeneratingVersionToRede: cartPresenter.isGeneratingVersionToRede,
        commandNumber: homePresenter.commandNumberMock!,
      );

      verify(() => ticketIsPermitted.verify(
            commandNumber: homePresenter.commandNumberMock!,
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          )).called(1);
    });

    test("Should call loadGroups, saleRequestTemp and PrintedProducts",
        () async {
      await sut.loadCommandData(
        printedProductsPresenter: sut,
        cartPresenter: cartPresenter,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
        clearPermissionToCancelProducts: true,
        isRemovingProduct: false,
        isGeneratingVersionToRede: cartPresenter.isGeneratingVersionToRede,
        commandNumber: homePresenter.commandNumberMock!,
      );

      verify(() => loadPrintedProducts.load(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            enterpriseId:
                EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
            commandNumber: int.parse(homePresenter.commandNumberMock!),
          )).called(1);
      verify(() => menuPresenter
          .getGroupsAndProducts(homePresenter.commandNumberMock!)).called(1);
      verify(() =>
              cartPresenter.loadSaleRequest(homePresenter.commandNumberMock!))
          .called(1);
    });

    test(
        "Should update commandNumber with null value on error to LoadCommandData",
        () async {
      ticketIsPermitted.mockError();

      await sut.loadCommandData(
        printedProductsPresenter: sut,
        cartPresenter: cartPresenter,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
        clearPermissionToCancelProducts: true,
        isRemovingProduct: false,
        isGeneratingVersionToRede: cartPresenter.isGeneratingVersionToRede,
        commandNumber: homePresenter.commandNumberMock!,
      );

      verify(() => homePresenter.updateCommandNumber(null)).called(1);
    });

    test("Should update CanCancelProducts to false when loadCommandData",
        () async {
      sut.updateCanCancelProducts(true);

      await sut.loadCommandData(
        printedProductsPresenter: sut,
        cartPresenter: cartPresenter,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
        clearPermissionToCancelProducts: true,
        isRemovingProduct: false,
        isGeneratingVersionToRede: cartPresenter.isGeneratingVersionToRede,
        commandNumber: homePresenter.commandNumberMock!,
      );

      expect(sut.canCancelProducts, false);
    });

    test("Should NOT update CanCancelProducts to false when loadCommandData",
        () async {
      sut.updateCanCancelProducts(true);

      await sut.loadCommandData(
        printedProductsPresenter: sut,
        cartPresenter: cartPresenter,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
        clearPermissionToCancelProducts: false,
        isRemovingProduct: false,
        isGeneratingVersionToRede: cartPresenter.isGeneratingVersionToRede,
        commandNumber: homePresenter.commandNumberMock!,
      );

      expect(sut.canCancelProducts, true);
    });
    test(
        "Should emit unexpectedError if isRemovingProduct and commandNumber is null",
        () async {
      sut.updateCanCancelProducts(true);
      homePresenter.commandNumberMock = null;

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.loadCommandData(
        printedProductsPresenter: sut,
        cartPresenter: cartPresenter,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
        clearPermissionToCancelProducts: false,
        isRemovingProduct: true,
        isGeneratingVersionToRede: cartPresenter.isGeneratingVersionToRede,
        commandNumber: "999",
      );
    });
    test("Should not read barcode when isGeneratingVersionToRede", () async {
      await sut.loadCommandData(
        printedProductsPresenter: sut,
        cartPresenter: cartPresenter,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
        clearPermissionToCancelProducts: false,
        isRemovingProduct: false,
        isGeneratingVersionToRede: true,
        commandNumber: homePresenter.commandNumberMock!,
      );

      verifyNever(() => barcodeScanner.read());
    });

    test(
        "Should update homePresenter.commandNumber if isGeneratingVersionToRede",
        () async {
      await sut.loadCommandData(
        printedProductsPresenter: sut,
        cartPresenter: cartPresenter,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
        clearPermissionToCancelProducts: false,
        isRemovingProduct: false,
        isGeneratingVersionToRede: true,
        commandNumber: "999",
      );

      verify(() => homePresenter.updateCommandNumber("999")).called(1);
    });
  });
}
