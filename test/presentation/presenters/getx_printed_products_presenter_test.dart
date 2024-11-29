import 'dart:typed_data';

import 'package:clean_celta_mobile/data/models/models.dart';
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
  late ExpansibleGroupFromProductPresenterSpy
      expansibleGroupFromProductPresenter;
  late PrintedProductsPresenterSpy printedProductsPresenter;

  late UserValidationsSpy userValidations;
  late LoadPrintedProductsSpy loadPrintedProducts;
  late RemovePrintedProductSpy removePrintedProduct;
  late FinishSaleRequestTempSpy finishSaleRequestTemp;
  late BarcodeScannerSpy barcodeScanner;
  late UpdateSaleRequestSpy updateSaleRequest;
  late PrintBitmapSpy printBitmap;
  late NavigateToSpy navigateTo;

  late PrintedEntity printedEntity;
  late SaleRequestTempEntity saleRequestTempEntity;

  late int personalizedCode;
  late String password;
  late String saleRequestProductId;
  late Uint8List bitmap;

  void initPresenters() {
    cartPresenter = CartPresenterSpy();
    menuPresenter = MenuPresenterSpy();
    homePresenter = HomePresenterSpy();
    expansibleGroupFromProductPresenter =
        ExpansibleGroupFromProductPresenterSpy();
    printedProductsPresenter = PrintedProductsPresenterSpy();

    sut = GetxPrintedProductsPresenter(
      userValidations: userValidations,
      loadPrintedProducts: loadPrintedProducts,
      removePrintedProduct: removePrintedProduct,
      updateSaleRequest: updateSaleRequest,
      printBitmap: printBitmap,
      navigateTo: navigateTo,
    );
  }

  void initUsecases() {
    userValidations = UserValidationsSpy();
    loadPrintedProducts = LoadPrintedProductsSpy();
    removePrintedProduct = RemovePrintedProductSpy();
    finishSaleRequestTemp = FinishSaleRequestTempSpy();
    barcodeScanner = BarcodeScannerSpy();
    updateSaleRequest = UpdateSaleRequestSpy();
    printBitmap = PrintBitmapSpy();
    navigateTo = NavigateToSpy();
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
    bitmap = Uint8List(faker.randomGenerator.integer(100));
  }

  void mockSuccess() {
    finishSaleRequestTemp.mockFinishSaleRequestTemp();
    userValidations.mockIsValidPassword(true);
    userValidations.mockCanCancel(true);
    loadPrintedProducts.mockLoadPrintedProducts(printedEntity);
    barcodeScanner.mockBarcodeScanner(homePresenter.commandNumberMock!);
    homePresenter.mockLoadCommandData();
  }

  setUp(() {
    initUsecases();
    initPresenters();
    initEntitys();
    mockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeSaleRequestTempEntity(0));
    registerFallbackValue(EntityFactory.makeProductsViewModel());
    registerFallbackValue(
        EntityFactory.makeExpansibleGroupFromProductViewModel());
    registerFallbackValue(HomePresenterSpy());
    registerFallbackValue(ExpansibleGroupFromProductPresenterSpy());
    registerFallbackValue(CartPresenterSpy());
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(MenuPresenterSpy());
    registerFallbackValue(
        EntityFactory.makeSaleRequestModel(covenantCode: 0, customerCode: 0));
    registerFallbackValue(Uint8List(faker.randomGenerator.integer(100)));
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

  group("Load printed products", () {
    test('Should emit correct values on success to loadPrintes', () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.loadPrinted(homePresenter.commandNumber!);
    });
    test('Should update printedProducts correctly on loadPrinted success',
        () async {
      await sut.loadPrinted(homePresenter.commandNumber!);

      expect(sut.printed, PrintedViewModel.fromEntity(printedEntity));
    });

    test(
        'Should clear printed products if the second search dont return anything',
        () async {
      await sut.loadPrinted(homePresenter.commandNumber!);
      expect(sut.printed, PrintedViewModel.fromEntity(printedEntity));

      loadPrintedProducts.mockLoadPrintedProducts(null);
      await sut.loadPrinted(homePresenter.commandNumber!);
      expect(sut.printed, null);
    });

    test("Should call loadPrintedProducts with correct values", () async {
      await sut.loadPrinted(homePresenter.commandNumber!);

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

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      final error = sut.loadPrinted(homePresenter.commandNumber!);

      expect(error, throwsA(DomainError.unexpected));
    });

    test("Should emit correct events on ticket is not permitted", () async {
      loadPrintedProducts.mockError(DomainError.commandNotAvailable);

      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.commandNotAvailable]));
      final error = sut.loadPrinted(homePresenter.commandNumber!);

      expect(error, throwsA(DomainError.commandNotAvailable));
    });

    test("Should clear printed on call clearPrinted", () async {
      await sut.loadPrinted(homePresenter.commandNumber!);
      sut.clear();

      expect(sut.printed, null);
    });

    test(
        "ShouldCall LoadCommandData on removeProduct success and dont update permission to cancel products",
        () async {
      sut.updateCanCancelProducts(true);

      await sut.removeProduct(
        printedProductsPresenter: printedProductsPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        saleRequestProductId: saleRequestProductId,
        menuPresenter: menuPresenter,
        cartPresenter: cartPresenter,
        commandNumber: homePresenter.commandNumber!,
      );

      verify(
        () => loadPrintedProducts.load(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          enterpriseId:
              EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
          commandNumber: homePresenter.commandNumberMock!.toInt(),
        ),
      ).called(1);
      expect(sut.canCancelProducts, true);
    });
    test("ShouldCall removeProduct on call sut.removeProduct", () async {
      await sut.removeProduct(
        printedProductsPresenter: printedProductsPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        saleRequestProductId: saleRequestProductId,
        menuPresenter: menuPresenter,
        cartPresenter: cartPresenter,
        commandNumber: homePresenter.commandNumber!,
      );

      verify(() => removePrintedProduct.remove(saleRequestProductId)).called(1);
    });

    test("Should emit correct values on removeProduct success", () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.removeProduct(
        printedProductsPresenter: printedProductsPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        saleRequestProductId: saleRequestProductId,
        menuPresenter: menuPresenter,
        cartPresenter: cartPresenter,
        commandNumber: homePresenter.commandNumber!,
      );
    });

    test("Should emit correct values on removeProduct throws", () async {
      removePrintedProduct.mockError();
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.removeProduct(
        printedProductsPresenter: printedProductsPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        saleRequestProductId: saleRequestProductId,
        menuPresenter: menuPresenter,
        cartPresenter: cartPresenter,
        commandNumber: homePresenter.commandNumber!,
      );
    });

    test("Should load printed products again when removeProduct throws",
        () async {
      removePrintedProduct.mockError();

      await sut.removeProduct(
        printedProductsPresenter: printedProductsPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        saleRequestProductId: saleRequestProductId,
        menuPresenter: menuPresenter,
        cartPresenter: cartPresenter,
        commandNumber: homePresenter.commandNumber!,
      );

      verify(() => loadPrintedProducts.load(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          enterpriseId:
              EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
          commandNumber: homePresenter.commandNumberMock!.toInt())).called(1);
    });

    test("Should emit correct values on removeProduct throws", () async {
      removePrintedProduct.mockError();
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.removeProduct(
        printedProductsPresenter: printedProductsPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        saleRequestProductId: saleRequestProductId,
        menuPresenter: menuPresenter,
        cartPresenter: cartPresenter,
        commandNumber: homePresenter.commandNumber!,
      );
    });

    test("Should emit correct values on ticket is not permitted", () async {
      removePrintedProduct.mockError();
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.removeProduct(
        printedProductsPresenter: printedProductsPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        saleRequestProductId: saleRequestProductId,
        menuPresenter: menuPresenter,
        cartPresenter: cartPresenter,
        commandNumber: homePresenter.commandNumber!,
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
        IncrementType: faker.randomGenerator.integer(2, min: 1),
        IncrementValue: faker.randomGenerator.decimal(),
      ));

      await sut.loadPrinted(homePresenter.commandNumber!);

      expect(sut.printed, null);
    });

    test('Should not emit isLoading', () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emits(false));

      await sut.loadPrinted(homePresenter.commandNumber!, showIsLoading: false);
    });
  });

  group("Do on close page", () {
    test("Should clear permission to cancel", () {
      sut.updateCanCancelProducts(true);

      expect(sut.canCancelProducts, true);
      sut.doOnClosePage();
      expect(sut.canCancelProducts, false);
    });
    test("Should update people quantity to zero", () {
      sut.updatePeopleQuantity(isAdding: true);

      sut.doOnClosePage();
      expect(sut.peopleQuantity, 1);
    });
  });

  group("Get total liquid", () {
    test("Should return 0 if printed products is null", () async {
      loadPrintedProducts.mockLoadPrintedProducts(null);
      await sut.loadPrinted(homePresenter.commandNumber!);

      expect(sut.getTotalLiquid(sut.printed), 0);
    });

    test("Should return correct value if incrementType is 1", () async {
      final printed = EntityFactory.makePrintedProductsEntity(incrementType: 1);

      loadPrintedProducts.mockLoadPrintedProducts(printed);

      await sut.loadPrinted(homePresenter.commandNumber!);

      double value =
          sut.getSubtotal(sut.printed) + sut.getServiceChargeValue(sut.printed);

      expect(sut.getTotalLiquid(sut.printed), value);
    });
    test("Should return correct value if incrementType is 2", () async {
      final printed = EntityFactory.makePrintedProductsEntity(incrementType: 2);

      loadPrintedProducts.mockLoadPrintedProducts(printed);

      await sut.loadPrinted(homePresenter.commandNumber!);

      expect(
        sut.getTotalLiquid(sut.printed),
        sut.getSubtotal(sut.printed) + sut.getServiceChargeValue(sut.printed),
      );
    });
    test("Should return correct value if incrementType is invalid", () async {
      final printed = EntityFactory.makePrintedProductsEntity(
        incrementType: faker.randomGenerator.integer(100, min: 3),
      );

      loadPrintedProducts.mockLoadPrintedProducts(printed);

      await sut.loadPrinted(homePresenter.commandNumber!);

      expect(
        sut.getTotalLiquid(sut.printed),
        printed.TotalLiquid.toDouble().toStringAsFixed(2).toDouble() +
            sut.getServiceChargeValue(sut.printed),
      );
    });
  });

  group("Get sub total", () {
    test("Should return 0 if printed products is null", () async {
      loadPrintedProducts.mockLoadPrintedProducts(null);
      await sut.loadPrinted(homePresenter.commandNumber!);

      expect(sut.getSubtotal(sut.printed), 0);
    });
    test("Should return total liquid of printed products", () async {
      await sut.loadPrinted(homePresenter.commandNumber!);

      expect(
        sut.getSubtotal(sut.printed),
        printedEntity.TotalLiquid.toStringAsFixed(2).toDouble(),
      );
    });
  });
  group("Remove service charge", () {
    test("Should emit correct values in success", () async {
      await sut.loadPrinted(homePresenter.commandNumber!);
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      // expectLater(sut.mainErrorStream, emits(null)); //dont works because in the loadPrinted already put null value in mainStream

      await sut.removeServiceCharge(
        userPersonalizedCode: personalizedCode,
        password: password,
        commandNumber: homePresenter.commandNumber!,
        printed: PrintedViewModel.fromEntity(printedEntity),
        validateUserAndPassword: true,
      );
    });
    test("Should emit correct values if throws", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      userValidations.mockIsValidPasswordError(DomainError.unexpected);

      await sut.removeServiceCharge(
        userPersonalizedCode: personalizedCode,
        password: password,
        commandNumber: homePresenter.commandNumber!,
        printed: PrintedViewModel.fromEntity(printedEntity),
        validateUserAndPassword: true,
      );
    });
    test("Should emit correct values if password is invalid", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.invalidCredentialsOrAccessDenied]));

      userValidations.mockIsValidPassword(false);

      await sut.removeServiceCharge(
        userPersonalizedCode: personalizedCode,
        password: password,
        commandNumber: homePresenter.commandNumber!,
        printed: PrintedViewModel.fromEntity(printedEntity),
        validateUserAndPassword: true,
      );
    });
    test("Should call validate user password with correct values", () async {
      await sut.loadPrinted(homePresenter.commandNumber!);
      await sut.removeServiceCharge(
        userPersonalizedCode: personalizedCode,
        password: password,
        commandNumber: homePresenter.commandNumber!,
        printed: PrintedViewModel.fromEntity(printedEntity),
        validateUserAndPassword: true,
      );

      verify(
        () => userValidations.isValidPassword(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          personalizedCode: personalizedCode,
          password: password,
        ),
      ).called(1);
    });
    test("Should call update sale request with correct values", () async {
      await sut.loadPrinted(homePresenter.commandNumber!);
      await sut.removeServiceCharge(
        userPersonalizedCode: personalizedCode,
        password: password,
        commandNumber: homePresenter.commandNumber!,
        printed: PrintedViewModel.fromEntity(printedEntity),
        validateUserAndPassword: true,
      );

      verify(
        () => updateSaleRequest.update(
          model: SaleRequestModel(
            CovenantCode: null,
            CustomerCode: null,
            IncrementType: 0,
            IncrementValue: 0,
            TotalLiquid: sut.printed!.TotalLiquid.toDouble(),
            EnterpriseId:
                EnterpriseDataBuilder.enterpriseDataEntity?.enterpriseId,
          ),
          commandNumberWithThreeNumbers:
              homePresenter.commandNumberMock!.padLeft(3, "0"),
          saleRequestId: sut.printed!.SaleRequestId.toInt(),
        ),
      ).called(1);
    });
    test("Should call loadPrinted", () async {
      await sut.loadPrinted(homePresenter.commandNumber!);
      await sut.removeServiceCharge(
        userPersonalizedCode: personalizedCode,
        password: password,
        commandNumber: homePresenter.commandNumber!,
        printed: PrintedViewModel.fromEntity(printedEntity),
        validateUserAndPassword: true,
      );

      verify(
        () => loadPrintedProducts.load(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          enterpriseId:
              EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
          commandNumber: homePresenter.commandNumberMock!.toInt(),
        ),
      ).called(2);
    });

    test(
        "Should not validate user credentials when validateUserAndPassword is false",
        () async {
      await sut.loadPrinted(homePresenter.commandNumber!);
      await sut.removeServiceCharge(
        userPersonalizedCode: personalizedCode,
        password: password,
        commandNumber: homePresenter.commandNumber!,
        printed: PrintedViewModel.fromEntity(printedEntity),
        validateUserAndPassword: false,
      );

      verifyNever(
        () => userValidations.isValidPassword(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          personalizedCode: personalizedCode,
          password: password,
        ),
      );
    });
  });

  group("Print printed products", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.printPrintedProducts(bitmap);
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      printBitmap.mockPrintBitmapError();

      await sut.printPrintedProducts(bitmap);
    });
    test("Should call printBitmap with correct values", () async {
      await sut.printPrintedProducts(bitmap);

      verify(() => printBitmap.print(bitmap)).called(1);
    });
  });

  group("Go to print products page", () {
    test("Should call navigateTo with correct route", () async {
      await sut.goToPrintProductsPage();

      verify(() => navigateTo.navigate(pageRoute: PageRoutes.printProducts))
          .called(1);
    });
  });

  group("Update people quantity", () {
    test("Should not reduce quantity if atual quantity is 1", () {
      expect(sut.peopleQuantity, 1);

      sut.updatePeopleQuantity(isAdding: false);

      expect(sut.peopleQuantity, 1);
    });

    test("Should add quantity if is adding", () {
      sut.updatePeopleQuantity(isAdding: true);
      expect(sut.peopleQuantity, 2);

      sut.updatePeopleQuantity(isAdding: true);
      expect(sut.peopleQuantity, 3);
    });

    test("Should update people quantity correctly", () {
      sut.updatePeopleQuantity(isAdding: false);
      expect(sut.peopleQuantity, 1);

      sut.updatePeopleQuantity(isAdding: true);
      expect(sut.peopleQuantity, 2);

      sut.updatePeopleQuantity(isAdding: false);
      expect(sut.peopleQuantity, 1);

      sut.updatePeopleQuantity(isAdding: false);
      expect(sut.peopleQuantity, 1);
    });
  });
}
