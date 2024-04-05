import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/presentation/protocols/protocols.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';

import '../../data/mocks/params_factory.dart';
import '../../domain/mocks/mocks.dart';

import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../domain/mocks/login_data_spy.dart';
import '../mocks/mocks.dart';

void main() {
  late GetxLoginPresenter sut;
  late AuthenticationSpy authentication;
  late ValidationSpy validation;
  late CrossIdSpy crossIdSpy;
  late SaveLoginDataSpy saveLoginData;
  late CrossIdEntity crossIdEntity;
  late LoginDataEntity loginDataEntity;
  late String password;

  setUp(() {
    password = faker.internet.password();

    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    crossIdSpy = CrossIdSpy();
    saveLoginData = SaveLoginDataSpy();

    loginDataEntity = EntityFactory.makeLoginData();
    crossIdEntity = EntityFactory.makeAccount();
    authentication.mockAuthentication(crossIdEntity);

    saveLoginData.mockSave(loginDataEntity);

    sut = GetxLoginPresenter(
      validation: validation,
      authentication: authentication,
      saveCrossId: crossIdSpy,
      saveLoginData: saveLoginData,
    );
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeAccount());
    registerFallbackValue(EntityFactory.makeLoginData());
    registerFallbackValue(ParamsFactory.makeAuthentication());
  });

  test('Should call Validation with correct user', () {
    final formData = {
      "userName": loginDataEntity.userName,
      'password': null,
      'url': null,
    };

    sut.validateUser(loginDataEntity.userName);

    verify(() => validation.validate(field: "userName", input: formData))
        .called(1);
  });

  test('Should emit invalidFieldError if user is invalid', () {
    validation.mockValidationError(value: ValidationError.invalidField);

    sut.userErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateUser(loginDataEntity.userName);
    sut.validateUser(loginDataEntity.userName);
  });

  test('Should emit requiredFieldError if user is empty', () {
    validation.mockValidationError(value: ValidationError.requiredField);

    sut.userErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateUser(loginDataEntity.userName);
    sut.validateUser(loginDataEntity.userName);
  });

  test('Should emit null if user validation succeeds', () {
    sut.userErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateUser(loginDataEntity.userName);
    sut.validateUser(loginDataEntity.userName);
  });
  test('Should call Validation with correct url', () {
    final formData = {
      "userName": null,
      'password': null,
      'url': loginDataEntity.url
    };

    sut.validateUrl(loginDataEntity.url);

    verify(() => validation.validate(field: "url", input: formData)).called(1);
  });

  test('Should emit invalidFieldError if url is invalid', () {
    validation.mockValidationError(value: ValidationError.invalidField);

    sut.urlErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateUrl(loginDataEntity.url);
    sut.validateUrl(loginDataEntity.url);
  });

  test('Should emit requiredFieldError if url is empty', () {
    validation.mockValidationError(value: ValidationError.requiredField);

    sut.urlErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateUrl(loginDataEntity.url);
    sut.validateUrl(loginDataEntity.url);
  });

  test('Should emit null if url validation succeeds', () {
    sut.urlErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateUrl(loginDataEntity.url);
    sut.validateUrl(loginDataEntity.url);
  });

  test('Should call Validation with correct password', () {
    final formData = {"userName": null, 'password': password, 'url': null};

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
        field: "userName", value: ValidationError.invalidField);

    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateUser(loginDataEntity.userName);
    sut.validatePassword(password);
  });

  test('Should enable form button if all fields are valid', () async {
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateUser(loginDataEntity.userName);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
    await Future.delayed(Duration.zero);
    sut.validateUrl(loginDataEntity.url);
    await Future.delayed(Duration.zero);
  });

  test('Should call Authentication with correct values', () async {
    sut.validateUser(loginDataEntity.userName);
    sut.validatePassword(password);
    sut.validateUrl(loginDataEntity.url);

    await sut.auth();

    verify(() => authentication.auth(AuthenticationParams(
          user: loginDataEntity.userName,
          password: password,
          url: loginDataEntity.url,
        ))).called(1);
  });

  test('Should call SaveCrossId with correct value', () async {
    sut.validateUser(loginDataEntity.userName);
    sut.validatePassword(password);
    sut.validateUrl(loginDataEntity.url);

    await sut.auth();

    verify(() => crossIdSpy.save(crossIdEntity)).called(1);
  });

  test('Should emit UnexpectedError if SaveCrossId fails', () async {
    crossIdSpy.mockSaveError();
    sut.validateUser(loginDataEntity.userName);
    sut.validatePassword(password);
    sut.validateUrl(loginDataEntity.url);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.auth();
  });

  test('Should call SaveLoginData with correct value', () async {
    sut.validateUser(loginDataEntity.userName);
    sut.validatePassword(password);
    sut.validateUrl(loginDataEntity.url);

    await sut.auth();

    verify(() => saveLoginData.save(LoginDataEntity(
        url: loginDataEntity.url,
        userName: loginDataEntity.userName))).called(1);
  });

  test('Should emit UnexpectedError if SaveLoginData fails', () async {
    saveLoginData.mockSaveError();
    sut.validateUser(loginDataEntity.userName);
    sut.validatePassword(password);
    sut.validateUrl(loginDataEntity.url);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.auth();
  });

  test('Should emit correct events on Authentication success', () async {
    sut.validateUser(loginDataEntity.userName);
    sut.validatePassword(password);
    sut.validateUrl(loginDataEntity.url);

    expectLater(sut.mainErrorStream, emits(null));
    expectLater(sut.isLoadingStream, emits(true));

    await sut.auth();
  });

  test('Should change page on success', () async {
    sut.validateUser(loginDataEntity.userName);
    sut.validatePassword(password);
    sut.validateUrl(loginDataEntity.url);

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
    sut.validateUser(loginDataEntity.userName);
    sut.validatePassword(password);
    sut.validateUrl(loginDataEntity.url);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.auth();
  });

  test('Should emit correct events on loadData', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.loadData();
  });

  // test("Should call LoadUser on loadData", () async {
  //   loadUserName.mockLoad(userName);
  //   loadUrl.mockLoad(url);
  //   await sut.loadData();

  //   verify(() => loadUserName.load()).called(1);
  //   verify(() => loadUrl.load()).called(1);
  // });
}
