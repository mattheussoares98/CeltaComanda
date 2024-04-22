import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/presentation/protocols/protocols.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';

import '../../domain/mocks/mocks.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';
import '../mocks/mocks.dart';

void main() {
  late GetxEnterpriseValidationPresenter sut;
  late ValidationSpy validation;
  late LocalEnterpriseDataSpy localEnterpriseData;
  late RemoteEnterpriseDataSpy remoteEnterpriseData;
  late NavigateToSpy navigateTo;
  late LoadApiSaleRequestSpy loadApiSaleRequest;

  setUp(() {
    validation = ValidationSpy();
    localEnterpriseData = LocalEnterpriseDataSpy();
    remoteEnterpriseData = RemoteEnterpriseDataSpy();
    navigateTo = NavigateToSpy();
    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();
    loadApiSaleRequest = LoadApiSaleRequestSpy();

    localEnterpriseData.mockAdd(EnterpriseDataBuilder.enterpriseDataEntity!);
    localEnterpriseData.mockLoad(EnterpriseDataBuilder.enterpriseDataEntity!);
    remoteEnterpriseData
        .mockRemoteLoad(EnterpriseDataBuilder.enterpriseDataEntity!);

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

  test('Should call SaveEnterpriseData with correct value', () async {
    sut.validateEnterpriseInput(
      sut.enterpriseNameController.text,
      updateEnterpriseNameController: true,
    );

    await sut.validateApiSaleRequest();

    verify(() => localEnterpriseData
        .add(EnterpriseDataBuilder.enterpriseDataEntity!)).called(1);
  });

  test('Should emit UnexpectedError if SaveEnterpriseData fails', () async {
    loadApiSaleRequest.mockError(DomainError.unexpected);
    sut.validateEnterpriseInput(sut.enterpriseNameController.text,
        updateEnterpriseNameController: true);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.validateApiSaleRequest();
  });

  test('Should emit correct events on validateApiSaleRequest success',
      () async {
    sut.validateEnterpriseInput(sut.enterpriseNameController.text,
        updateEnterpriseNameController: true);

    expectLater(sut.mainErrorStream, emits(null));
    expectLater(sut.isLoadingStream, emits(true));

    await sut.validateApiSaleRequest();
  });

  test('Should error if enterprise not exists in firebase', () {
    remoteEnterpriseData.mockRemoteLoadError();
    // sut.validateEnterpriseInput(sut.enterpriseNameController.text,
    //     updateEnterpriseNameController: true);

    final error = sut.loadRemoteData();

    expect(error, throwsA(DomainError.enterpriseOrUrlNotFound));
  });

  test('Should go to ExpansibleGroupsPage on success', () async {
    sut.validateEnterpriseInput(sut.enterpriseNameController.text,
        updateEnterpriseNameController: true);

    await sut.validateApiSaleRequest();

    verify(() => navigateTo.navigate(pageRoute: PageRoutes.expansibleGroups))
        .called(1);
  });

  test("Should call LoadRemoteData on loadData", () async {
    await sut.loadRemoteData();

    verify(() => remoteEnterpriseData.load()).called(1);
  });
  test("Should change controllers with remoteEnterpriseData", () async {
    await sut.loadRemoteData();

    expect(EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseName,
        sut.enterpriseNameController.text);
  });

  test("Should change controllers with cacheEnterpriseData", () async {
    await sut.loadLocalData();

    expect(EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseName,
        sut.enterpriseNameController.text);
  });
  test("Should call remoteLoadEnterpriseData on ValidateApiSaleRequest click",
      () async {
    sut.validateEnterpriseInput(sut.enterpriseNameController.text);
    sut.isUpdatedEnterpriseName = true;

    await sut.validateApiSaleRequest();

    verify(() => remoteEnterpriseData.load()).called(1);
  });

  test(
      "Should change EnterpriseDataBuilder.enterpriseName when change enterprise value",
      () async {
    sut.validateEnterpriseInput(
      sut.enterpriseNameController.text,
      updateEnterpriseNameController: true,
    );

    expect(
        EnterpriseDataBuilder.enterpriseDataEntity,
        EnterpriseEntity(
          enterpriseName: sut.enterpriseNameController.text,
        ));
  });
}
