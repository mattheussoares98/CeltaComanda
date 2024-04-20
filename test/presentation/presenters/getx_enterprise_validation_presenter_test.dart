import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/presentation/presenters/getx_enterprise_validation_presenter.dart';
import 'package:clean_celta_mobile/presentation/protocols/protocols.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';

import '../../domain/mocks/mocks.dart';

import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import '../mocks/mocks.dart';

void main() {
  late GetxEnterpriseValidationPresenter sut;
  late ValidationSpy validation;
  late LocalLoadLoginDataSpy localLoginData;
  late LoginDataEntity loginData;
  late RemoteLoginDataSpy remoteLoginData;
  late NavigateToSpy navigateTo;
  late LoadApiSaleRequestSpy loadApiSaleRequest;

  setUp(() {
    validation = ValidationSpy();
    localLoginData = LocalLoadLoginDataSpy();
    remoteLoginData = RemoteLoginDataSpy();
    navigateTo = NavigateToSpy();
    loginData = EntityFactory.makeLoginData();
    loadApiSaleRequest = LoadApiSaleRequestSpy();

    localLoginData.mockSave(loginData);
    localLoginData.mockLoad(loginData);
    remoteLoginData.mockRemoteLoad(loginData);
    // remoteLoginData.mockAdd(loginData);

    sut = GetxEnterpriseValidationPresenter(
      validation: validation,
      localLoginData: localLoginData,
      remoteLoginData: remoteLoginData,
      navigateTo: navigateTo,
      loadApiSaleRequest: loadApiSaleRequest,
    );

    sut.enterpriseNameController.text = loginData.enterpriseName!;
    sut.urlController.text = loginData.url;
    sut.userNameController.text = loginData.userName;
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeLoginData());
  });

  test('Should emit null if enterpriseName validation succeeds', () {
    sut.enterpriseErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, true)));

    sut.validateEnterpriseInput(sut.enterpriseNameController.text);
    sut.validateEnterpriseInput(sut.enterpriseNameController.text);
  });
  test('Should disable form button if enterpriseName field is invalid', () {
    validation.mockValidationError(
        field: "enterpriseName", value: ValidationError.invalidField);

    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEnterpriseInput(sut.enterpriseNameController.text);
  });

  test('Should enable form button enterpriseName are valid', () async {
    expectLater(sut.isFormValidStream, emits(true));

    sut.validateEnterpriseInput(sut.enterpriseNameController.text);
    await Future.delayed(Duration.zero);
  });

  test('Should call SaveLoginData with correct value', () async {
    sut.validateEnterpriseInput(sut.enterpriseNameController.text);

    await sut.validateApiSaleRequest();

    verify(() => localLoginData.add(loginData)).called(2);
  });

  test('Should emit UnexpectedError if SaveLoginData fails', () async {
    localLoginData.mockSaveError();
    sut.validateEnterpriseInput(sut.enterpriseNameController.text);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.validateApiSaleRequest();
  });

  test('Should emit correct events on validateApiSaleRequest success',
      () async {
    sut.validateEnterpriseInput(sut.enterpriseNameController.text);

    expectLater(sut.mainErrorStream, emits(null));
    expectLater(sut.isLoadingStream, emits(true));

    await sut.validateApiSaleRequest();
  });

  test('Should go to ExpansibleGroupsPage on success', () async {
    sut.validateEnterpriseInput(sut.enterpriseNameController.text);

    await sut.validateApiSaleRequest();

    verify(() => navigateTo.navigate(pageRoute: PageRoutes.expansibleGroups))
        .called(1);
  });

  test("Should call LoadRemoteData on loadData", () async {
    await sut.loadRemoteData();

    verify(() => remoteLoginData.load()).called(1);
  });
  test("Should change controllers with remoteLoginData", () async {
    await sut.loadRemoteData();

    expect(loginData.enterpriseName, sut.enterpriseNameController.text);
  });

  test("Should change controllers with cacheLoginData", () async {
    await sut.loadLocalData();

    expect(loginData.enterpriseName, sut.enterpriseNameController.text);
  });
  test("Should call remoteLoadLoginData on ValidateApiSaleRequest click",
      () async {
    sut.validateEnterpriseInput(sut.enterpriseNameController.text);
    sut.isUpdatedEnterpriseName = true;

    await sut.validateApiSaleRequest();

    verify(() => remoteLoginData.load(loginEntity: loginData)).called(1);
  });
}
