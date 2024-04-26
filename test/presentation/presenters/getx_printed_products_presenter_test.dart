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
  late int personalizedCode;
  late String password;

  setUp(() {
    personalizedCode = faker.randomGenerator.integer(5);
    password = faker.randomGenerator.string(5);
    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();

    userValidations = UserValidationsSpy();
    sut = GetxPrintedProductsPresenter(
      userValidations: userValidations,
    );
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

    test('Should show invalidCredentials UIError on invalid credential', () async {
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

    test('Should show invalidCredentials UIError on invalid credential', () async {
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
}
