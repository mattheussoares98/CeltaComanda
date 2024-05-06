import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:faker/faker.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../domain/mocks/mocks.dart';
import '../../ui/mocks/mocks.dart';

void main() {
  late GetxPrintedProductsPresenter sut;
  late SaleRequestTempPresenterSpy saleRequestTempPresenter;
  late ExpansibleGroupsPresenterSpy expansibleGroupsPresenter;

  late UserValidationsSpy userValidations;
  late LoadPrintedProductsSpy loadPrintedProducts;
  late RemovePrintedProductSpy removePrintedProduct;

  late PrintedEntity printedEntity;

  late int personalizedCode;
  late String password;
  late String saleRequestProductId;

  setUp(() {
    personalizedCode = faker.randomGenerator.integer(5);
    password = faker.randomGenerator.string(5);
    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();
    printedEntity = EntityFactory.makePrintedProductsEntity();
    saleRequestProductId = faker.randomGenerator.integer(5).toString();

    userValidations = UserValidationsSpy();
    loadPrintedProducts = LoadPrintedProductsSpy();
    removePrintedProduct = RemovePrintedProductSpy();

    saleRequestTempPresenter = SaleRequestTempPresenterSpy();
    expansibleGroupsPresenter = ExpansibleGroupsPresenterSpy();
    expansibleGroupsPresenter.commandNumberMock =
        faker.randomGenerator.integer(3).toString();

    sut = GetxPrintedProductsPresenter(
      userValidations: userValidations,
      loadPrintedProducts: loadPrintedProducts,
      removePrintedProduct: removePrintedProduct,
    );

    loadPrintedProducts.mockLoadPrintedProducts(printedEntity);
  });

  setUpAll(() {
    registerFallbackValue(SaleRequestTempPresenterSpy());
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(ExpansibleGroupsPresenterSpy());
  });

  group("Validate password", () {
    test('Should call isValidPassword with correct values', () async {
      await sut.removeProduct(
        saleRequestProductId: saleRequestProductId,
        personalizedCode: personalizedCode,
        password: password,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
        printedProductsPresenter: sut,
        saleRequestTempPresenter: saleRequestTempPresenter,
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
        personalizedCode: personalizedCode,
        password: password,
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
        personalizedCode: personalizedCode,
        password: password,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
        printedProductsPresenter: sut,
        saleRequestTempPresenter: saleRequestTempPresenter,
      );
    });

    test('Should show accessDenied UIError on user dont have permission',
        () async {
      userValidations.mockIsValidPasswordError(DomainError.accessDenied);

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.accessDenied]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.removeProduct(
        saleRequestProductId: saleRequestProductId,
        personalizedCode: personalizedCode,
        password: password,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
        printedProductsPresenter: sut,
        saleRequestTempPresenter: saleRequestTempPresenter,
      );
    });

    test('Should show unexpected UIError on unexpected error', () async {
      userValidations.mockIsValidPasswordError(DomainError.unexpected);

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.removeProduct(
        saleRequestProductId: saleRequestProductId,
        personalizedCode: personalizedCode,
        password: password,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
        printedProductsPresenter: sut,
        saleRequestTempPresenter: saleRequestTempPresenter,
      );
    });
  });
  group("Verify user can cancel", () {
    test('Should emit correct values on success canCancel', () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.removeProduct(
        saleRequestProductId: saleRequestProductId,
        personalizedCode: personalizedCode,
        password: password,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
        printedProductsPresenter: sut,
        saleRequestTempPresenter: saleRequestTempPresenter,
      );
    });
    test('Should call userCanCancel with correct values', () async {
      await sut.removeProduct(
        saleRequestProductId: saleRequestProductId,
        personalizedCode: personalizedCode,
        password: password,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
        printedProductsPresenter: sut,
        saleRequestTempPresenter: saleRequestTempPresenter,
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

    test('Should show invalidCredentials UIError on invalid credential',
        () async {
      userValidations.mockCanCancelError(DomainError.invalidCredentials);

      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.invalidCredentials]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.removeProduct(
        saleRequestProductId: saleRequestProductId,
        personalizedCode: personalizedCode,
        password: password,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
        printedProductsPresenter: sut,
        saleRequestTempPresenter: saleRequestTempPresenter,
      );
    });

    test('Should show accessDenied UIError on user dont have permission',
        () async {
      userValidations.mockCanCancelError(DomainError.accessDenied);

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.accessDenied]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.removeProduct(
        saleRequestProductId: saleRequestProductId,
        personalizedCode: personalizedCode,
        password: password,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
        printedProductsPresenter: sut,
        saleRequestTempPresenter: saleRequestTempPresenter,
      );
    });

    test('Should show unexpected UIError on unexpected error', () async {
      userValidations.mockCanCancelError(DomainError.unexpected);

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.removeProduct(
        saleRequestProductId: saleRequestProductId,
        personalizedCode: personalizedCode,
        password: password,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
        printedProductsPresenter: sut,
        saleRequestTempPresenter: saleRequestTempPresenter,
      );
    });
  });

  group("Manipulate data", () {
    test('Should emit correct values on success loadData', () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.load(expansibleGroupsPresenter.commandNumberMock!);
    });
    test("Should call loadPrintedProducts with correct values", () async {
      await sut.load(expansibleGroupsPresenter.commandNumberMock!);

      verify(() => loadPrintedProducts.load(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            enterpriseId:
                EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
            commandNumber:
                int.parse(expansibleGroupsPresenter.commandNumberMock!),
          )).called(1);
    });

    test("Should return correct printedProducts on LoadPrintedProducts",
        () async {
      final result = await loadPrintedProducts.load(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        commandNumber: int.parse(expansibleGroupsPresenter.commandNumberMock!),
      );

      expect(result, printedEntity);
    });

    test("Should return null on loadPrintedProducts", () async {
      loadPrintedProducts.mockLoadPrintedProducts(null);
      final result = await loadPrintedProducts.load(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        commandNumber: int.parse(expansibleGroupsPresenter.commandNumberMock!),
      );

      expect(result, null);
    });

    test("Should emit correct events", () async {
      loadPrintedProducts.mockError();

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.load(expansibleGroupsPresenter.commandNumberMock!);
    });

    test("Should clear printed on call clearPrinted", () async {
      sut.clear();

      expect(sut.printedProducts, null);
    });

    test(
        "ShouldCall ExpansibleGroupsPresenter.load on removeProduct success to data",
        () async {
      await sut.removeProduct(
        personalizedCode: personalizedCode,
        password: password,
        saleRequestProductId: saleRequestProductId,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        printedProductsPresenter: sut,
      );

      verify(() => expansibleGroupsPresenter.load(
            commandNumber: expansibleGroupsPresenter.commandNumberMock!,
            printedProductsPresenter: sut,
            saleRequestTempPresenter: saleRequestTempPresenter,
          )).called(1);
    });
  });
}
