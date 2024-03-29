import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/presentation/protocols/protocols.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import '../mocks/mocks.dart';

void main() {
  late GetxLoginPresenter sut;
  late AuthenticationSpy authentication;
  late ValidationSpy validation;
  late SaveCrossIdSpy saveCrossId;
  late String user;
  late String password;
  late String urlCcs;
  late CrossIdEntity account;

  setUp(() {
    account = EntityFactory.makeAccount();
    user = faker.person.name();
    password = faker.internet.password();
    urlCcs = faker.internet.httpUrl();
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    authentication.mockAuthentication(account);
    saveCrossId = SaveCrossIdSpy();
    sut = GetxLoginPresenter(
        validation: validation,
        authentication: authentication,
        saveCrossId: saveCrossId);
  });

  setUpAll(() {
    registerFallbackValue(ParamsFactory.makeAuthentication());
    registerFallbackValue(EntityFactory.makeAccount());
  });

  test('Should call Validation with correct user', () {
    final formData = {"user": user, 'password': null, 'ccsUrl': null};

    sut.validateUser(user);

    verify(() => validation.validate(field: "user", input: formData)).called(1);
  });

  test('Should emit invalidFieldError if user is invalid', () {
    validation.mockValidationError(value: ValidationError.invalidField);

    sut.userErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateUser(user);
    sut.validateUser(user);
  });

  test('Should emit requiredFieldError if user is empty', () {
    validation.mockValidationError(value: ValidationError.requiredField);

    sut.userErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateUser(user);
    sut.validateUser(user);
  });

  test('Should emit null if user validation succeeds', () {
    sut.userErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateUser(user);
    sut.validateUser(user);
  });
  test('Should call Validation with correct urlCcs', () {
    final formData = {"user": null, 'password': null, 'ccsUrl': urlCcs};

    sut.validateUrlCcs(urlCcs);

    verify(() => validation.validate(field: "urlCcs", input: formData)).called(1);
  });

  test('Should emit invalidFieldError if urlCcs is invalid', () {
    validation.mockValidationError(value: ValidationError.invalidField);

    sut.urlCcsErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateUrlCcs(urlCcs);
    sut.validateUrlCcs(urlCcs);
  });

  test('Should emit requiredFieldError if urlCcs is empty', () {
    validation.mockValidationError(value: ValidationError.requiredField);

    sut.urlCcsErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateUrlCcs(urlCcs);
    sut.validateUrlCcs(urlCcs);
  });

  test('Should emit null if urlCcs validation succeeds', () {
    sut.urlCcsErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateUrlCcs(urlCcs);
    sut.validateUrlCcs(urlCcs);
  });

  test('Should call Validation with correct password', () {
    final formData = {"user": null, 'password': password, 'ccsUrl': null};

    sut.validatePassword(password);

    verify(() => validation.validate(field: 'password', input: formData))
        .called(1);
  });

  test('Should emit requiredFieldError if password is empty', () {
    validation.mockValidationError(value: ValidationError.requiredField);

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit null if validation succeeds', () {
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should disable form button if any field is invalid', () {
    validation.mockValidationError(
        field: "user", value: ValidationError.invalidField);

    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateUser(user);
    sut.validatePassword(password);
  });

  test('Should enable form button if all fields are valid', () async {
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateUser(user);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
    await Future.delayed(Duration.zero);
    sut.validateUrlCcs(urlCcs);
    await Future.delayed(Duration.zero);
  });

  test('Should call Authentication with correct values', () async {
    sut.validateUser(user);
    sut.validatePassword(password);

    await sut.auth();

    verify(() => authentication.auth(AuthenticationParams(
          user: user,
          password: password,
        ))).called(1);
  });

  test('Should call SaveCrossId with correct value', () async {
    sut.validateUser(user);
    sut.validatePassword(password);

    await sut.auth();

    verify(() => saveCrossId.save(account)).called(1);
  });

  test('Should emit UnexpectedError if SaveCrossId fails', () async {
    saveCrossId.mockSaveError();
    sut.validateUser(user);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.auth();
  });

  test('Should emit correct events on Authentication success', () async {
    sut.validateUser(user);
    sut.validatePassword(password);

    expectLater(sut.mainErrorStream, emits(null));
    expectLater(sut.isLoadingStream, emits(true));

    await sut.auth();
  });

  test('Should change page on success', () async {
    sut.validateUser(user);
    sut.validatePassword(password);

    sut.navigateToStream
        .listen(expectAsync1((page) => expect(page, '/home')));

    await sut.auth();
  });

  // test('Should emit correct events on InvalidCredentialsError', () async {
  //   authentication.mockAuthenticationError(DomainError.invalidCredentials);
  //   sut.validateUser(user);
  //   sut.validatePassword(password);

  //   expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
  //   expectLater(
  //       sut.mainErrorStream, emitsInOrder([null, UIError.invalidCredentials]));

  //   await sut.auth();
  // });

  test('Should emit correct events on UnexpectedError', () async {
    authentication.mockAuthenticationError(DomainError.unexpected);
    sut.validateUser(user);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.auth();
  });
}
