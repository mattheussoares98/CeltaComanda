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
  late RemoteEnterpriseDataSpy remoteLoadEnterpriseData;
  late NavigateToSpy navigateTo;
  late TicketIsPermittedSpy ticketIsPermitted;
  late LocalUseFixedCommandNumberSpy localUseFixedCommandNumber;

  late TicketIsPermittedEntity ticketIsPermittedEntity;

  setUp(() {
    validation = ValidationSpy();
    localUseFixedCommandNumber = LocalUseFixedCommandNumberSpy();
    localEnterpriseData = LocalEnterpriseDataSpy();
    remoteLoadEnterpriseData = RemoteEnterpriseDataSpy();
    navigateTo = NavigateToSpy();
    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();
    ticketIsPermitted = TicketIsPermittedSpy();

    localEnterpriseData.mockAdd(EnterpriseDataBuilder.enterpriseDataEntity!);
    localEnterpriseData.mockLoad(EnterpriseDataBuilder.enterpriseDataEntity!);
    remoteLoadEnterpriseData
        .mockRemoteLoad(EnterpriseDataBuilder.enterpriseDataEntity!);

    ticketIsPermittedEntity = EntityFactory.makeTicketIsPermittedEntity();
    ticketIsPermitted.mockTicketIsPermitted(ticketIsPermittedEntity);

    localUseFixedCommandNumber.mockUpdate();

    sut = GetxEnterpriseValidationPresenter(
      validation: validation,
      localEntepriseData: localEnterpriseData,
      loadEnterpriseData: remoteLoadEnterpriseData,
      navigateTo: navigateTo,
      ticketIsPermitted: ticketIsPermitted,
      useFixedCommandNumber: localUseFixedCommandNumber,
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

  test("Should emit correct events on validation throws", () async {
    ticketIsPermitted.mockError();

    expectLater(
        sut.mainErrorStream, emitsInOrder([null, UIError.commandNotAvailable]));
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.getEnterpriseAndValidateApiIsAvailable(isFixedCommandNumber: false);
  });

  test("Should not change page if validation throws", () async {
    ticketIsPermitted.mockError();

    verifyNever(
      () => navigateTo.navigate(
        pageRoute: PageRoutes.home,
        clear: true,
      ),
    );
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

    await sut.getEnterpriseAndValidateApiIsAvailable(isFixedCommandNumber: false);

    verify(() => localEnterpriseData
        .add(EnterpriseDataBuilder.enterpriseDataEntity!)).called(1);
  });

  test('Should emit UnexpectedError if SaveEnterpriseData fails', () async {
    localEnterpriseData.mockAddError();
    sut.validateEnterpriseInput(sut.enterpriseNameController.text,
        updateEnterpriseNameController: true);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.getEnterpriseAndValidateApiIsAvailable(isFixedCommandNumber: false);
  });

  test('Should emit correct events on validateApiSaleRequest success',
      () async {
    sut.validateEnterpriseInput(sut.enterpriseNameController.text,
        updateEnterpriseNameController: true);

    expectLater(sut.mainErrorStream, emits(null));
    expectLater(sut.isLoadingStream, emits(true));

    await sut.getEnterpriseAndValidateApiIsAvailable(isFixedCommandNumber: false);
  });

  test('Should error if enterprise not exists in firebase', () {
    remoteLoadEnterpriseData.mockRemoteLoadError();
    // sut.validateEnterpriseInput(sut.enterpriseNameController.text,
    //     updateEnterpriseNameController: true);

    final error = sut.loadRemoteEnterpriseData();

    expect(error, throwsA(DomainError.enterpriseOrUrlNotFound));
  });

  test('Should throw enterpriseNotFound when remoteEnterpriseData returns null',
      () {
    remoteLoadEnterpriseData.mockRemoteLoad(null);

    final error = sut.loadRemoteEnterpriseData();

    expect(error, throwsA(DomainError.enterpriseOrUrlNotFound));
  });

  test('Should go to ExpansibleGroupsPage on success', () async {
    sut.validateEnterpriseInput(sut.enterpriseNameController.text,
        updateEnterpriseNameController: true);

    await sut.getEnterpriseAndValidateApiIsAvailable(isFixedCommandNumber: false);

    verify(() => navigateTo.navigate(pageRoute: PageRoutes.home, clear: true))
        .called(1);
  });

  test("Should call LoadRemoteData on loadData", () async {
    await sut.loadRemoteEnterpriseData();

    verify(() => remoteLoadEnterpriseData.load()).called(1);
  });
  test("Should change controllers with remoteEnterpriseData", () async {
    await sut.loadRemoteEnterpriseData();

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

    await sut.getEnterpriseAndValidateApiIsAvailable(isFixedCommandNumber: false);

    verify(() => remoteLoadEnterpriseData.load()).called(1);
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

  test("Should go to HomePage cleaning atual route", () async {
    sut.goToHomePage();

    verify(
      () => navigateTo.navigate(
        pageRoute: PageRoutes.home,
        clear: true,
      ),
    ).called(1);
  });

  group("Fixed command number", () {
    test("Should emit correct values on change useFixedCommandNumber", () {
      expectLater(sut.useFixedCommandNumberStream, emitsInOrder([true, false]));

      sut.updateUseFixedCommandNumber();
      sut.updateUseFixedCommandNumber();
    });

    test(
        "Should update correctly locally useFixedCommandNumber on validateApiSaleRequest",
        () async {
      await sut.getEnterpriseAndValidateApiIsAvailable(isFixedCommandNumber: true);
      verify(() => localUseFixedCommandNumber.update(true)).called(1);

      await sut.getEnterpriseAndValidateApiIsAvailable(isFixedCommandNumber: false);
      verify(() => localUseFixedCommandNumber.update(false)).called(1);
    });
  });
}
