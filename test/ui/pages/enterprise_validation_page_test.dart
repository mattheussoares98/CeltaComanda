import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';

import '../../domain/mocks/mocks.dart';
import '../../presentation/mocks/mocks.dart';

import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GetxEnterpriseValidationPresenter sut;
  late ValidationSpy validation;
  late LocalEnterpriseDataSpy localEnterpriseData;
  late LoadApiSaleRequestSpy loadApiSaleRequest;
  late String password;
  late RemoteEnterpriseDataSpy remoteEnterpriseData;
  late NavigateToSpy navigateTo;

  setUp(() {
    password = faker.internet.password();

    validation = ValidationSpy();
    localEnterpriseData = LocalEnterpriseDataSpy();
    remoteEnterpriseData = RemoteEnterpriseDataSpy();
    navigateTo = NavigateToSpy();
    loadApiSaleRequest = LoadApiSaleRequestSpy();

    EnterpriseDataBuilder.enterpriseDataEntity = EntityFactory.makeEnterpriseData();

    localEnterpriseData.mockSave(EnterpriseDataBuilder.enterpriseDataEntity!);
    localEnterpriseData.mockLoad(EnterpriseDataBuilder.enterpriseDataEntity!);
    remoteEnterpriseData.mockRemoteLoad(EnterpriseDataBuilder.enterpriseDataEntity);

    sut = GetxEnterpriseValidationPresenter(
      validation: validation,
      localEntepriseData: localEnterpriseData,
      remoteEnterpriseData: remoteEnterpriseData,
      navigateTo: navigateTo,
      loadApiSaleRequest: loadApiSaleRequest,
    );

    sut.enterpriseNameController.text =
        EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseName;
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeEnterpriseData());
  });

  test('Should emit null if enterpriseName validation succeeds', () {
    sut.enterpriseErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, true)));

    sut.validateEnterpriseInput(sut.enterpriseNameController.text);
    sut.validateEnterpriseInput(sut.enterpriseNameController.text);
  });

  test('Should call Validation with correct enterpriseName', () {
    final formData = {
      'enterpriseName': sut.enterpriseNameController.text,
    };

    sut.validateEnterpriseInput(sut.enterpriseNameController.text);

    verify(() => validation.validate(field: 'enterpriseName', input: formData))
        .called(1);
  });

  test('Should emit null if validation succeeds', () {
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, true)));

    sut.validateEnterpriseInput(password);
  });

  test('Should enable form button if all fields are valid', () async {
    expectLater(sut.isFormValidStream, emits(true));

    sut.validateEnterpriseInput(sut.enterpriseNameController.text);
    await Future.delayed(Duration.zero);
  });

  test('Should call saveLocalEnterpriseData when validate api request', () async {
    await sut.validateApiSaleRequest();

    verify(() => localEnterpriseData.add(EnterpriseDataBuilder.enterpriseDataEntity!))
        .called(1);
  });

  test('Should call SaveEnterpriseData with correct value', () async {
    await sut.loadRemoteData();

    verify(() => remoteEnterpriseData.load()).called(1);
  });

  test('Should emit correct events on Authentication success', () async {
    sut.validateEnterpriseInput(
      sut.enterpriseNameController.text,
      updateEnterpriseNameController: true,
    );

    expectLater(sut.mainErrorStream, emits(null));
    expectLater(sut.isLoadingStream, emits(true));

    await sut.validateApiSaleRequest();
  });

  test('Should go to ExpansibleGroupsPage on success', () async {
    sut.validateEnterpriseInput(
      sut.enterpriseNameController.text,
      updateEnterpriseNameController: true,
    );

    await sut.validateApiSaleRequest();

    verify(() => navigateTo.navigate(pageRoute: PageRoutes.expansibleGroups))
        .called(1);
  });

  test("Should call RemoteLoadData", () async {
    await sut.loadRemoteData();

    verify(() => remoteEnterpriseData.load()).called(1);
  });
  test("Should call LocalLoadData", () async {
    await sut.loadLocalData();

    verify(() => localEnterpriseData.load()).called(1);
  });
  test("Should change controllers with cacheEnterpriseData", () async {
    await sut.loadRemoteData();

    expect(EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseName,
        sut.enterpriseNameController.text);
  });
  test("Should call remoteLoadEnterpriseData on enterprise click", () async {
    sut.validateEnterpriseInput(
      sut.enterpriseNameController.text,
      updateEnterpriseNameController: true,
    );

    await sut.validateApiSaleRequest();

    verify(() => remoteEnterpriseData.load()).called(1);
  });

  test("Should update enterpriseNameController with local data", () async {
    await sut.loadLocalData();

    expect(EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseName,
        sut.enterpriseNameController.text);
  });
}
