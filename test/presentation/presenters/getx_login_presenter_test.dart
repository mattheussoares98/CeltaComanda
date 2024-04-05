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
  late LocalLoginDataSpy loginData;
  late CrossIdEntity crossIdEntity;
  late LoginDataEntity loginDataEntity;
  late String password;

  setUp(() {
    password = faker.internet.password();

    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    crossIdSpy = CrossIdSpy();
    loginData = LocalLoginDataSpy();

    loginDataEntity = EntityFactory.makeLoginData();
    crossIdEntity = EntityFactory.makeAccount();
    authentication.mockAuthentication(crossIdEntity);

    loginData.mockSave(loginDataEntity);
    loginData.mockLoad(loginDataEntity);

    sut = GetxLoginPresenter(
      validation: validation,
      authentication: authentication,
      saveCrossId: crossIdSpy,
      localLoginData: loginData,
    );

    sut.userNameController.text = faker.person.name();
    sut.urlController.text = faker.internet.httpUrl();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeAccount());
    registerFallbackValue(EntityFactory.makeLoginData());
    registerFallbackValue(ParamsFactory.makeAuthentication());
  });

  test('Should call Validation with correct user', () {
    final formData = {
      "userName": sut.userNameController.text,
      'password': null,
      'url': sut.urlController.text,
    };

    sut.validateUser(sut.userNameController.text);

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
      "userName": sut.userNameController.text,
      'password': null,
      'url': sut.urlController.text
    };

    sut.validateUrl(sut.urlController.text);

    verify(() => validation.validate(field: "url", input: formData)).called(1);
  });

  test('Should emit invalidFieldError if url is invalid', () {
    validation.mockValidationError(value: ValidationError.invalidField);

    sut.urlErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateUrl(sut.urlController.text);
    sut.validateUrl(sut.urlController.text);
  });

  test('Should emit requiredFieldError if url is empty', () {
    validation.mockValidationError(value: ValidationError.requiredField);

    sut.urlErrorStream
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateUrl(sut.urlController.text);
    sut.validateUrl(sut.urlController.text);
  });

  test('Should emit null if url validation succeeds', () {
    sut.urlErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateUrl(sut.urlController.text);
    sut.validateUrl(sut.urlController.text);
  });

  test('Should call Validation with correct password', () {
    final formData = {
      "userName": sut.userNameController.text,
      'password': password,
      'url': sut.urlController.text,
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
        .listen(expectAsync1((isValid) => expect(isValid, true)));

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
    sut.validateUrl(sut.urlController.text);
    await Future.delayed(Duration.zero);
  });

  test('Should call Authentication with correct values', () async {
    sut.validateUser(loginDataEntity.userName);
    sut.validatePassword(password);
    sut.validateUrl(sut.urlController.text);

    await sut.auth();

    verify(() => authentication.auth(AuthenticationParams(
          user: loginDataEntity.userName,
          password: password,
          url: sut.urlController.text,
        ))).called(1);
  });

  test('Should call SaveCrossId with correct value', () async {
    sut.validateUser(loginDataEntity.userName);
    sut.validatePassword(password);
    sut.validateUrl(sut.urlController.text);

    await sut.auth();

    verify(() => crossIdSpy.save(crossIdEntity)).called(1);
  });

  test('Should emit UnexpectedError if SaveCrossId fails', () async {
    crossIdSpy.mockSaveError();
    sut.validateUser(loginDataEntity.userName);
    sut.validatePassword(password);
    sut.validateUrl(sut.urlController.text);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.auth();
  });

  test('Should call SaveLoginData with correct value', () async {
    sut.validateUser(loginDataEntity.userName);
    sut.validatePassword(password);
    sut.validateUrl(sut.urlController.text);

    await sut.auth();

    verify(() => loginData.save(LoginDataEntity(
        url: sut.urlController.text,
        userName: loginDataEntity.userName))).called(1);
  });

  test('Should emit UnexpectedError if SaveLoginData fails', () async {
    loginData.mockSaveError();
    sut.validateUser(loginDataEntity.userName);
    sut.validatePassword(password);
    sut.validateUrl(sut.urlController.text);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.auth();
  });

  test('Should emit correct events on Authentication success', () async {
    sut.validateUser(loginDataEntity.userName);
    sut.validatePassword(password);
    sut.validateUrl(sut.urlController.text);

    expectLater(sut.mainErrorStream, emits(null));
    expectLater(sut.isLoadingStream, emits(true));

    await sut.auth();
  });

  test('Should change page on success', () async {
    sut.validateUser(loginDataEntity.userName);
    sut.validatePassword(password);
    sut.validateUrl(sut.urlController.text);

    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/home')));

    await sut.auth();
  });

  test('Should emit correct events on UnexpectedError', () async {
    authentication.mockAuthenticationError(DomainError.unexpected);
    sut.validateUser(loginDataEntity.userName);
    sut.validatePassword(password);
    sut.validateUrl(sut.urlController.text);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.auth();
  });

  test('Should emit correct events on loadData', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.loadData();
  });

  test("Should call LoadUser on loadData", () async {
    await sut.loadData();

    verify(() => loginData.load()).called(1);
  });
  test("Should change controllers with cacheLoginData", () async {
    await sut.loadData();

    expect(loginDataEntity.url, sut.urlController.text);
    expect(loginDataEntity.userName, sut.userNameController.text);
  });
}
