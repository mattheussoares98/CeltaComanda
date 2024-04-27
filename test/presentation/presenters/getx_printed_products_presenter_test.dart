import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:faker/faker.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../domain/mocks/mocks.dart';

void main() {
  late GetxPrintedProductsPresenter sut;
  late UserValidationsSpy userValidations;
  late LoadPrintedProductsSpy loadPrintedProducts;
  late PrintedEntity printedEntity;
  late int personalizedCode;
  late String password;
  late String commandNumber;

  setUp(() {
    personalizedCode = faker.randomGenerator.integer(5);
    password = faker.randomGenerator.string(5);
    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();
    commandNumber = faker.randomGenerator.integer(3).toString();
    printedEntity = EntityFactory.makePrintedProductsEntity();

    userValidations = UserValidationsSpy();
    loadPrintedProducts = LoadPrintedProductsSpy();
    sut = GetxPrintedProductsPresenter(
      userValidations: userValidations,
      loadPrintedProducts: loadPrintedProducts,
    );

    loadPrintedProducts.mockLoadPrintedProducts(printedEntity);
  });

  group("Validate password", () {
    test('Should call isValidPassword with correct values', () async {
      await sut.isValidPasswordAndCanCancel(
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
      final validPassword = await sut.isValidPasswordAndCanCancel(
        personalizedCode: personalizedCode,
        password: password,
      );

      expect(validPassword, true);
    });

    test('Should show invalidCredentials UIError on invalid credential',
        () async {
      userValidations.mockIsValidPasswordError(DomainError.invalidCredentials);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.invalidCredentials]));

      await sut.isValidPasswordAndCanCancel(
        personalizedCode: personalizedCode,
        password: password,
      );
    });

    test('Should show accessDenied UIError on user dont have permission',
        () async {
      userValidations.mockIsValidPasswordError(DomainError.accessDenied);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.accessDenied]));

      await sut.isValidPasswordAndCanCancel(
        personalizedCode: personalizedCode,
        password: password,
      );
    });

    test('Should show unexpected UIError on unexpected error', () async {
      userValidations.mockIsValidPasswordError(DomainError.unexpected);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.isValidPasswordAndCanCancel(
        personalizedCode: personalizedCode,
        password: password,
      );
    });

    test('Should return false invalid password', () async {
      userValidations.mockIsValidPasswordError(DomainError.invalidCredentials);

      final validPassword = await sut.isValidPasswordAndCanCancel(
        personalizedCode: personalizedCode,
        password: password,
      );

      expect(validPassword, false);
    });
  });
  group("Verify user can cancel", () {
    test('Should call userCanCancel with correct values', () async {
      await sut.isValidPasswordAndCanCancel(
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
      final canCancel = await sut.isValidPasswordAndCanCancel(
        personalizedCode: personalizedCode,
        password: password,
      );

      expect(canCancel, true);
    });

    test('Should show invalidCredentials UIError on invalid credential',
        () async {
      userValidations.mockCanCancelError(DomainError.invalidCredentials);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.invalidCredentials]));

      await sut.isValidPasswordAndCanCancel(
        personalizedCode: personalizedCode,
        password: password,
      );
    });

    test('Should show accessDenied UIError on user dont have permission',
        () async {
      userValidations.mockCanCancelError(DomainError.accessDenied);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.accessDenied]));

      await sut.isValidPasswordAndCanCancel(
        personalizedCode: personalizedCode,
        password: password,
      );
    });

    test('Should show unexpected UIError on unexpected error', () async {
      userValidations.mockCanCancelError(DomainError.unexpected);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.isValidPasswordAndCanCancel(
        personalizedCode: personalizedCode,
        password: password,
      );
    });

    test('Should return false on user cant cancel', () async {
      userValidations.mockCanCancelError(DomainError.invalidCredentials);

      final canCancel = await sut.isValidPasswordAndCanCancel(
        personalizedCode: personalizedCode,
        password: password,
      );

      expect(canCancel, false);
    });
  });

  group("Manipulate data", () {
    test("Should call loadPrintedProducts with correct values", () async {
      await sut.getPrintedProducts(commandNumber);

      verify(() => loadPrintedProducts.load(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            enterpriseId:
                EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
            commandNumber: int.parse(commandNumber),
          )).called(1);
    });

    test("Should return correct printedProducts on LoadPrintedProducts",
        () async {
      final result = await loadPrintedProducts.load(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        commandNumber: int.parse(commandNumber),
      );

      expect(result, printedEntity);
    });

    test("Should return null on loadPrintedProducts", () async {
      loadPrintedProducts.mockLoadPrintedProducts(null);
      final result = await loadPrintedProducts.load(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        commandNumber: int.parse(commandNumber),
      );

      expect(result, null);
    });

    test("Should emit correct events", () async {
      loadPrintedProducts.mockError();

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.getPrintedProducts(commandNumber);
    });

    test("Should clear printed on call clearPrinted", () async {
      sut.clearPrintedProducts();

      expect(sut.printedProducts, null);
    });
  });
}
