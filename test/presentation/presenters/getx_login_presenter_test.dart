import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:clean_celta_mobile/infra/helpers/helperts.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/presentation/protocols/protocols.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';

import '../../data/mocks/params_factory.dart';
import '../../domain/mocks/load_user_spy.dart';
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
  late SaveUrlSpy saveUrl;
  late LoadUrlSpy loadUrl;
  late SaveUserNameSpy saveUser;
  late LoadUserNameSpy loadUserName;
  late CrossIdEntity account;
  late String userName;
  late String password;
  late String url;

  setUp(() {
    account = EntityFactory.makeAccount();
    userName = faker.person.name();
    password = faker.internet.password();
    url = faker.internet.httpUrl();
    saveUrl = SaveUrlSpy();
    saveUser = SaveUserNameSpy();
    loadUrl = LoadUrlSpy();
    loadUserName = LoadUserNameSpy();
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    authentication.mockAuthentication(account);
    saveCrossId = SaveCrossIdSpy();
    sut = GetxLoginPresenter(
      validation: validation,
      authentication: authentication,
      saveCrossId: saveCrossId,
      saveUrl: saveUrl,
      saveUserName: saveUser,
      loadUrl: loadUrl,
      loadUserName: loadUserName,
    );
  });

  setUpAll(() {
    registerFallbackValue(ParamsFactory.makeAuthentication());
    registerFallbackValue(EntityFactory.makeAccount());
  });

  test('Should call Validation with correct user', () {
    final formData = {
      "user": userName,
      'password': null,
      CacheKeys.url.name: null
    };

    sut.validateUser(userName);

    verify(() => validation.validate(field: "user", input: formData)).called(1);
  });

  test('Should emit invalidFieldError if user is invalid', () {
    validation.mockValidationError(value: ValidationError.invalidField);

    sut.userErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateUser(userName);
    sut.validateUser(userName);
  });

  test('Should emit requiredFieldError if user is empty', () {
    validation.mockValidationError(value: ValidationError.requiredField);

    sut.userErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateUser(userName);
    sut.validateUser(userName);
  });

  test('Should emit null if user validation succeeds', () {
    sut.userErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateUser(userName);
    sut.validateUser(userName);
  });
  test('Should call Validation with correct url', () {
    final formData = {"user": null, 'password': null, CacheKeys.url.name: url};

    sut.validateUrl(url);

    verify(() => validation.validate(field: "url", input: formData)).called(1);
  });

  test('Should emit invalidFieldError if url is invalid', () {
    validation.mockValidationError(value: ValidationError.invalidField);

    sut.urlErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateUrl(url);
    sut.validateUrl(url);
  });

  test('Should emit requiredFieldError if url is empty', () {
    validation.mockValidationError(value: ValidationError.requiredField);

    sut.urlErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateUrl(url);
    sut.validateUrl(url);
  });

  test('Should emit null if url validation succeeds', () {
    sut.urlErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateUrl(url);
    sut.validateUrl(url);
  });

  test('Should call Validation with correct password', () {
    final formData = {
      "user": null,
      'password': password,
      CacheKeys.url.name: null
    };

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

    sut.validateUser(userName);
    sut.validatePassword(password);
  });

  test('Should enable form button if all fields are valid', () async {
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateUser(userName);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
    await Future.delayed(Duration.zero);
    sut.validateUrl(url);
    await Future.delayed(Duration.zero);
  });

  test('Should call Authentication with correct values', () async {
    sut.validateUser(userName);
    sut.validatePassword(password);
    sut.validateUrl(url);

    await sut.auth();

    verify(() => authentication.auth(AuthenticationParams(
          user: userName,
          password: password,
          url: url,
        ))).called(1);
  });

  test('Should call SaveCrossId with correct value', () async {
    sut.validateUser(userName);
    sut.validatePassword(password);
    sut.validateUrl(url);

    await sut.auth();

    verify(() => saveCrossId.save(account)).called(1);
  });

  test('Should call SaveUrl with correct value', () async {
    sut.validateUser(userName);
    sut.validatePassword(password);
    sut.validateUrl(url);

    await sut.auth();

    verify(() => saveUrl.save(url)).called(1);
  });

  test('Should call SaveUser with correct value', () async {
    sut.validateUser(userName);
    sut.validatePassword(password);
    sut.validateUrl(url);

    await sut.auth();

    verify(() => saveUser.save(userName)).called(1);
  });

  test('Should emit UnexpectedError if SaveCrossId fails', () async {
    saveCrossId.mockSaveError();
    sut.validateUser(userName);
    sut.validatePassword(password);
    sut.validateUrl(url);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.auth();
  });

  test('Should emit correct events on Authentication success', () async {
    sut.validateUser(userName);
    sut.validatePassword(password);
    sut.validateUrl(url);

    expectLater(sut.mainErrorStream, emits(null));
    expectLater(sut.isLoadingStream, emits(true));

    await sut.auth();
  });

  test('Should change page on success', () async {
    sut.validateUser(userName);
    sut.validatePassword(password);
    sut.validateUrl(url);

    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/home')));

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
    sut.validateUser(userName);
    sut.validatePassword(password);
    sut.validateUrl(url);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.auth();
  });

  test("Should call LoadUser on loadData", () async {
    loadUserName.mockLoad(userName);
    loadUrl.mockLoad(url);
    await sut.loadData();

    verify(() => loadUserName.load()).called(1);
    verify(() => loadUrl.load()).called(1);
  });
}
