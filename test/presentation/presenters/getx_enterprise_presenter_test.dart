import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/presentation/protocols/protocols.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import '../../domain/mocks/mocks.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';
import '../../ui/mocks/mocks.dart';
import '../mocks/mocks.dart';

void main() {
  late GetxEnterpriseValidationPresenter sut;
  late HomePresenterSpy homePresenter;

  late ValidationSpy validation;
  late LocalEnterpriseDataSpy localEnterpriseData;
  late RemoteEnterpriseDataSpy remoteLoadEnterpriseData;
  late NavigateToSpy navigateTo;
  late TicketIsPermittedSpy ticketIsPermitted;
  late LoadCommandDataSpy loadCommandData;

  late TicketIsPermittedEntity ticketIsPermittedEntity;
  late CommandEntity commandEntity;

  setUp(() {
    validation = ValidationSpy();
    loadCommandData = LoadCommandDataSpy();
    localEnterpriseData = LocalEnterpriseDataSpy();
    remoteLoadEnterpriseData = RemoteEnterpriseDataSpy();
    ticketIsPermitted = TicketIsPermittedSpy();
    navigateTo = NavigateToSpy();

    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();
    ticketIsPermittedEntity = EntityFactory.makeTicketIsPermittedEntity();
    commandEntity = EntityFactory.makeCommandEntity();

    localEnterpriseData.mockAdd(EnterpriseDataBuilder.enterpriseDataEntity!);
    localEnterpriseData.mockLoad(EnterpriseDataBuilder.enterpriseDataEntity!);
    remoteLoadEnterpriseData
        .mockRemoteLoad(EnterpriseDataBuilder.enterpriseDataEntity!);
    ticketIsPermitted.mockTicketIsPermitted(ticketIsPermittedEntity);
    loadCommandData.mockUpdate();
    loadCommandData.mockLoad(commandEntity);

    homePresenter = HomePresenterSpy();
    sut = GetxEnterpriseValidationPresenter(
      validation: validation,
      localEntepriseData: localEnterpriseData,
      loadEnterpriseData: remoteLoadEnterpriseData,
      navigateTo: navigateTo,
      ticketIsPermitted: ticketIsPermitted,
      loadCommandData: loadCommandData,
    );

    sut.enterpriseNameController.text =
        EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseName;
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeEnterpriseData());
    registerFallbackValue(EntityFactory.makeCommandEntity());
    registerFallbackValue(EntityFactory.makeProductViewModel());
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(CartPresenterSpy());
    registerFallbackValue(MenuPresenterSpy());
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

    await sut.getEnterpriseAndValidateApiIsAvailable(
        commandEntity: commandEntity);
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

    await sut.getEnterpriseAndValidateApiIsAvailable(
        commandEntity: commandEntity);

    verify(() => localEnterpriseData
        .add(EnterpriseDataBuilder.enterpriseDataEntity!)).called(1);
  });

  test('Should emit UnexpectedError if SaveEnterpriseData fails', () async {
    localEnterpriseData.mockAddError();
    sut.validateEnterpriseInput(sut.enterpriseNameController.text,
        updateEnterpriseNameController: true);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.getEnterpriseAndValidateApiIsAvailable(
        commandEntity: commandEntity);
  });

  test('Should emit correct events on validateApiSaleRequest success',
      () async {
    sut.validateEnterpriseInput(sut.enterpriseNameController.text,
        updateEnterpriseNameController: true);

    expectLater(sut.mainErrorStream, emits(null));
    expectLater(sut.isLoadingStream, emits(true));

    await sut.getEnterpriseAndValidateApiIsAvailable(
        commandEntity: commandEntity);
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

    await sut.getEnterpriseAndValidateApiIsAvailable(
        commandEntity: commandEntity);

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

    await sut.getEnterpriseAndValidateApiIsAvailable(
        commandEntity: commandEntity);

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

  test("Should call loadCommandData on loadLocalData", () async {
    await sut.loadLocalData();

    verify(() => loadCommandData.load()).called(1);
  });

  test("Should emit correct events on loadLocalData success", () async {
    expectLater(sut.mainErrorStream, emits(null));
    expectLater(sut.commandDataStream,
        emits(CommandViewModel.fromEntity(commandEntity)));
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.loadLocalData();
  });

  test("Should emit correct events on loadCommandData throws", () async {
    loadCommandData.mockLoadError();

    expectLater(sut.mainErrorStream, emits(null));
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(
        sut.commandDataStream,
        emits(
          const CommandViewModel(commandNumber: "", isFixedCommandNumber: ""),
        ));

    await sut.loadLocalData();
  });

  group("Fixed command number", () {
    test("Should emit correct values on change useFixedCommandNumber",
        () async {
      expectLater(sut.commandDataStream, emits(commandEntity));

      homePresenter.commandNumberMock = commandEntity.commandNumber;
      homePresenter.isFixedCommandNumberMock =
          commandEntity.isFixedCommandNumber;

      sut.updateUseFixedCommandNumber(homePresenter);
    });

    test(
        "Should update correctly locally useFixedCommandNumber on validateApiSaleRequest",
        () async {
      await sut.getEnterpriseAndValidateApiIsAvailable(
        commandEntity: commandEntity,
      );
      verify(() => loadCommandData.update(commandEntity)).called(1);

      await sut.getEnterpriseAndValidateApiIsAvailable(
          commandEntity: commandEntity);
      verify(() => loadCommandData.update(commandEntity)).called(1);
    });
  });
}
