import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/presentation/protocols/protocols.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:faker/faker.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';
import '../../ui/mocks/mocks.dart';
import '../mocks/mocks.dart';

void main() {
  late GetxEnterprisePresenter sut;
  late HomePresenterSpy homePresenter;

  late ValidationSpy validation;
  late LocalEnterpriseDataSpy localEnterpriseData;
  late RemoteEnterpriseDataSpy remoteLoadEnterpriseData;
  late NavigateToSpy navigateTo;
  late CommandInformationsSpy ticketIsPermitted;
  late LocalCommandDataSpy loadCommandData;
  late PersistentSpy persistent;
  late LoadEnterpriseConcentradorParametersSpy
      loadEnterpriseConcentradorParameters;

  late TicketIsPermittedEntity ticketIsPermittedEntity;
  late CommandEntity commandEntity;
  late EnterpriseEntity enterpriseEntity;
  late EnterpriseConcentradorParametersEntity
      enterpriseConcentradorParametersEntity;

  setUp(() {
    validation = ValidationSpy();
    loadCommandData = LocalCommandDataSpy();
    localEnterpriseData = LocalEnterpriseDataSpy();
    remoteLoadEnterpriseData = RemoteEnterpriseDataSpy();
    ticketIsPermitted = CommandInformationsSpy();
    navigateTo = NavigateToSpy();
    persistent = PersistentSpy();
    loadEnterpriseConcentradorParameters =
        LoadEnterpriseConcentradorParametersSpy();

    enterpriseEntity = EntityFactory.makeEnterpriseData();
    EnterpriseDataBuilder.enterpriseDataEntity = enterpriseEntity;
    ticketIsPermittedEntity = EntityFactory.makeTicketIsPermittedEntity();
    commandEntity = EntityFactory.makeCommandEntity();
    enterpriseConcentradorParametersEntity =
        EntityFactory.makeEnterpriseConcentradorParametersEntity();

    localEnterpriseData.mockAdd(EnterpriseDataBuilder.enterpriseDataEntity!);
    localEnterpriseData.mockLoad(EnterpriseDataBuilder.enterpriseDataEntity!);
    remoteLoadEnterpriseData
        .mockRemoteLoad(EnterpriseDataBuilder.enterpriseDataEntity!);
    ticketIsPermitted.mockTicketIsPermitted(ticketIsPermittedEntity);
    loadCommandData.mockUpdate();
    loadCommandData.mockLoad(commandEntity);
    loadEnterpriseConcentradorParameters
        .mockLoadEnterprise(enterpriseConcentradorParametersEntity);

    homePresenter = HomePresenterSpy();
    sut = GetxEnterprisePresenter(
      validation: validation,
      localEntepriseData: localEnterpriseData,
      loadEnterpriseData: remoteLoadEnterpriseData,
      navigateTo: navigateTo,
      commandInformations: ticketIsPermitted,
      localCommandData: loadCommandData,
      persistent: persistent,
      loadEnterpriseConcentradorParameters:
          loadEnterpriseConcentradorParameters,
    );

    sut.enterpriseNameController.text =
        EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseName;
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeEnterpriseData());
    registerFallbackValue(EntityFactory.makeCommandEntity());
    registerFallbackValue(EntityFactory.makeProductsViewModel());
    registerFallbackValue(
        EntityFactory.makeExpansibleGroupFromProductViewModel());
    registerFallbackValue(ExpansibleGroupFromProductPresenterSpy());
    registerFallbackValue(MenuPresenterSpy());
    registerFallbackValue(CartPresenterSpy());
    registerFallbackValue(HomePresenterSpy());
    registerFallbackValue(PrintedProductsPresenterSpy());
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
    ticketIsPermitted.mockErrorTicketIsPermitted();

    expectLater(
        sut.mainErrorStream, emitsInOrder([null, UIError.commandNotAvailable]));
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.validateApiAndGoToHomePage(
      commandEntity: commandEntity,
      homePresenter: homePresenter,
    );
  });

  test("Should not change page if validation throws", () async {
    ticketIsPermitted.mockErrorTicketIsPermitted();

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

    await sut.validateApiAndGoToHomePage(
      commandEntity: commandEntity,
      homePresenter: homePresenter,
    );

    verify(() => localEnterpriseData
        .add(EnterpriseDataBuilder.enterpriseDataEntity!)).called(1);
  });

  test('Should emit UnexpectedError if SaveEnterpriseData fails', () async {
    localEnterpriseData.mockAddError();
    sut.validateEnterpriseInput(sut.enterpriseNameController.text,
        updateEnterpriseNameController: true);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.validateApiAndGoToHomePage(
      commandEntity: commandEntity,
      homePresenter: homePresenter,
    );
  });

  test('Should emit correct events on validateApiSaleRequest success',
      () async {
    sut.validateEnterpriseInput(sut.enterpriseNameController.text,
        updateEnterpriseNameController: true);

    expectLater(sut.mainErrorStream, emits(null));
    expectLater(sut.isLoadingStream, emits(true));

    await sut.validateApiAndGoToHomePage(
      commandEntity: commandEntity,
      homePresenter: homePresenter,
    );
  });

  test('Should go to ExpansibleGroupsPage on success', () async {
    sut.validateEnterpriseInput(sut.enterpriseNameController.text,
        updateEnterpriseNameController: true);

    await sut.validateApiAndGoToHomePage(
      commandEntity: commandEntity,
      homePresenter: homePresenter,
    );

    verify(() => navigateTo.navigate(pageRoute: PageRoutes.home, clear: true))
        .called(1);
  });

  test("Should change controllers with cacheEnterpriseData", () async {
    await sut.getLocalData(homePresenter);

    expect(EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseName,
        sut.enterpriseNameController.text);
  });
  test("Should call remoteLoadEnterpriseData on ValidateApiSaleRequest click",
      () async {
    sut.validateEnterpriseInput(sut.enterpriseNameController.text);
    sut.isUpdatedEnterpriseName = true;

    await sut.validateApiAndGoToHomePage(
      commandEntity: commandEntity,
      homePresenter: homePresenter,
    );

    verify(() => remoteLoadEnterpriseData.load()).called(1);
  });

  test(
      "Should change EnterpriseDataBuilder.enterpriseName when change enterprise value",
      () async {
    sut.validateEnterpriseInput(
      sut.enterpriseNameController.text,
      updateEnterpriseNameController: true,
    );

    expect(EnterpriseDataBuilder.enterpriseDataEntity?.enterpriseName,
        sut.enterpriseNameController.text);
  });

  test("Should go to HomePage cleaning atual route", () async {
    await sut.goToHomePage(homePresenter);

    verify(
      () => navigateTo.navigate(
        pageRoute: PageRoutes.home,
        clear: true,
      ),
    ).called(1);
  });
  test(
      "Should make persist app when go to home page and enterprise.persist app is true",
      () async {
    EnterpriseDataBuilder.enterpriseDataEntity = EnterpriseEntity(
      enterpriseName:
          EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseName,
      url: EnterpriseDataBuilder.enterpriseDataEntity!.url,
      enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId,
      concentradorUrl:
          EnterpriseDataBuilder.enterpriseDataEntity!.concentradorUrl,
      persistApp: true,
      urlCCS: EnterpriseDataBuilder.enterpriseDataEntity!.urlCCS,
      useCovenant: EnterpriseDataBuilder.enterpriseDataEntity!.useCovenant,
      enterpriseConcentradorParametersEntity: EnterpriseDataBuilder
          .enterpriseDataEntity!.enterpriseConcentradorParametersEntity,
      updateMenuCount:
          EnterpriseDataBuilder.enterpriseDataEntity!.updateMenuCount,
      updateEnterpriseCount:
          EnterpriseDataBuilder.enterpriseDataEntity!.updateEnterpriseCount,
      serviceChargePercentageOrValue: EnterpriseDataBuilder
          .enterpriseDataEntity!.serviceChargePercentageOrValue,
      serviceChargeType:
          EnterpriseDataBuilder.enterpriseDataEntity!.serviceChargeType,
      updateDevicesInformations:
          EnterpriseDataBuilder.enterpriseDataEntity!.updateDevicesInformations,
    );
    await sut.goToHomePage(homePresenter);

    verify(() => persistent.makePersistent()).called(1);
  });
  test(
      "Should make NOT persist app when go to home page and enterprise.persist app is true and is generating version to rede",
      () async {
    EnterpriseDataBuilder.enterpriseDataEntity = EnterpriseEntity(
      enterpriseName:
          EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseName,
      url: EnterpriseDataBuilder.enterpriseDataEntity!.url,
      enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId,
      concentradorUrl:
          EnterpriseDataBuilder.enterpriseDataEntity!.concentradorUrl,
      persistApp: true,
      urlCCS: EnterpriseDataBuilder.enterpriseDataEntity!.urlCCS,
      useCovenant: EnterpriseDataBuilder.enterpriseDataEntity!.useCovenant,
      enterpriseConcentradorParametersEntity: EnterpriseDataBuilder
          .enterpriseDataEntity!.enterpriseConcentradorParametersEntity,
      updateMenuCount:
          EnterpriseDataBuilder.enterpriseDataEntity!.updateMenuCount,
      updateEnterpriseCount:
          EnterpriseDataBuilder.enterpriseDataEntity!.updateEnterpriseCount,
      serviceChargePercentageOrValue: EnterpriseDataBuilder
          .enterpriseDataEntity!.serviceChargePercentageOrValue,
      serviceChargeType:
          EnterpriseDataBuilder.enterpriseDataEntity!.serviceChargeType,
      updateDevicesInformations:
          EnterpriseDataBuilder.enterpriseDataEntity!.updateDevicesInformations,
    );
    homePresenter.isGeneratingVersionToRedeMock = true;
    await sut.goToHomePage(homePresenter);

    verify(() => persistent.makeNotPersistent()).called(1);
  });
  test(
      "Should make NOT persist app when go to home page and enterprise.persist app is false",
      () async {
    EnterpriseDataBuilder.enterpriseDataEntity = EnterpriseEntity(
      enterpriseName:
          EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseName,
      url: EnterpriseDataBuilder.enterpriseDataEntity!.url,
      enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId,
      concentradorUrl:
          EnterpriseDataBuilder.enterpriseDataEntity!.concentradorUrl,
      persistApp: false,
      urlCCS: EnterpriseDataBuilder.enterpriseDataEntity!.urlCCS,
      useCovenant: EnterpriseDataBuilder.enterpriseDataEntity!.useCovenant,
      enterpriseConcentradorParametersEntity: EnterpriseDataBuilder
          .enterpriseDataEntity!.enterpriseConcentradorParametersEntity,
      updateMenuCount:
          EnterpriseDataBuilder.enterpriseDataEntity!.updateMenuCount,
      updateEnterpriseCount:
          EnterpriseDataBuilder.enterpriseDataEntity!.updateEnterpriseCount,
      serviceChargePercentageOrValue: EnterpriseDataBuilder
          .enterpriseDataEntity!.serviceChargePercentageOrValue,
      serviceChargeType:
          EnterpriseDataBuilder.enterpriseDataEntity!.serviceChargeType,
      updateDevicesInformations:
          EnterpriseDataBuilder.enterpriseDataEntity!.updateDevicesInformations,
    );
    await sut.goToHomePage(homePresenter);

    verify(() => persistent.makeNotPersistent()).called(1);
  });

  test("Should call loadCommandData on loadLocalData", () async {
    await sut.getLocalData(homePresenter);

    verify(() => loadCommandData.load()).called(1);
  });

  test("Should emit correct events on loadLocalData success", () async {
    expectLater(sut.mainErrorStream, emits(null));
    expectLater(sut.commandDataStream,
        emits(CommandViewModel.fromEntity(commandEntity)));
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.getLocalData(homePresenter);
  });

  test("Should emit correct events on loadCommandData throws", () async {
    loadCommandData.mockLoadError();

    expectLater(sut.mainErrorStream, emits(null));
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(
        sut.commandDataStream,
        emits(
          const CommandViewModel(
              commandNumber: null, isFixedCommandNumber: null),
        ));

    await sut.getLocalData(homePresenter);
  });

  group("Fixed command number", () {
    test("Should emit correct values on change useFixedCommandNumber",
        () async {
      expectLater(sut.commandDataStream,
          emits(CommandViewModel.fromEntity(commandEntity)));

      homePresenter.commandNumberMock = commandEntity.commandNumber;
      homePresenter.isFixedCommandNumberMock =
          !commandEntity.isFixedCommandNumber;

      sut.updateUseFixedCommandNumber(homePresenter);
    });

    test(
        "Should update correctly locally useFixedCommandNumber on validateApiSaleRequest",
        () async {
      await sut.validateApiAndGoToHomePage(
        commandEntity: commandEntity,
        homePresenter: homePresenter,
      );
      verify(() => loadCommandData.update(commandEntity)).called(1);

      await sut.validateApiAndGoToHomePage(
        commandEntity: commandEntity,
        homePresenter: homePresenter,
      );
      verify(() => loadCommandData.update(commandEntity)).called(1);
    });

    test("Should call homePresenter.updateIsFixedCommandNumber", () async {
      await sut.updateUseFixedCommandNumber(homePresenter);

      verify(() => homePresenter.updateIsFixedCommandNumber()).called(1);
    });

    test(
        "Should call homePresenter.updateCommandNumber when call sut.updateCommandNumber",
        () async {
      final newCommandNumber = faker.randomGenerator.integer(999).toString();
      sut.updateCommandNumber(
        homePresenter: homePresenter,
        newCommandValue: newCommandNumber,
      );

      verify(() => homePresenter
          .updateCommandNumber(newCommandNumber.padLeft(3, "0"))).called(1);
    });

    test(
        "Should update commandViewModel.commandNumber when call sut.updateCommandNumber",
        () async {
      final newCommandNumber = faker.randomGenerator.integer(999).toString();

      expectLater(
          sut.commandDataStream,
          emits(
            CommandViewModel(
                commandNumber: newCommandNumber.toString().padLeft(3, "0"),
                isFixedCommandNumber: "false"),
          ));

      sut.updateCommandNumber(
        homePresenter: homePresenter,
        newCommandValue: newCommandNumber,
      );
    });

    test("Should update command number with pad left if number is less than 3",
        () async {
      expectLater(
          sut.commandDataStream,
          emits(
            const CommandViewModel(
                commandNumber: "001", isFixedCommandNumber: "false"),
          ));

      sut.updateCommandNumber(
        homePresenter: homePresenter,
        newCommandValue: "1",
      );

      verify(() => homePresenter.updateCommandNumber("001")).called(1);
    });

    test(
        "Should update EnterpriseDataBuilder.enterpriseName when validateEnterpriseInput",
        () async {
      String enterpriseName = faker.randomGenerator.string(20);

      sut.validateEnterpriseInput(enterpriseName);

      expect(
        EnterpriseDataBuilder.enterpriseDataEntity,
        EnterpriseEntity(
          enterpriseName: enterpriseName,
          url: null,
          enterpriseId: null,
          concentradorUrl: null,
          persistApp: null,
          urlCCS: null,
          useCovenant: null,
          enterpriseConcentradorParametersEntity: null,
          updateMenuCount: null,
          updateEnterpriseCount: null,
          serviceChargePercentageOrValue: null,
          serviceChargeType: null,
          updateDevicesInformations: null,
        ),
      );
    });

    test(
        "Should update homePresenter.isFixedCommandNumber when load command data",
        () async {
      await sut.getLocalData(homePresenter);
      expect(homePresenter.isFixedCommandNumber, false);

      loadCommandData.mockLoad(
        CommandEntity(
          commandNumber: faker.randomGenerator.integer(100).toString(),
          isFixedCommandNumber: true,
        ),
      );

      await sut.getLocalData(homePresenter);
      verify(() => homePresenter.updateIsFixedCommandNumber()).called(1);
    });
  });

  group("Load remote enterprise data", () {
    test('Should error if enterprise not exists in firebase', () async {
      remoteLoadEnterpriseData
          .mockRemoteLoadError(DomainError.enterpriseOrUrlNotFound);

      final error = sut.getFirebaseAndConcentradorEnterpriseParameters();

      expect(error, throwsA(DomainError.enterpriseOrUrlNotFound));
    });

    test(
        'Should throw enterpriseNotFound when remoteEnterpriseData returns null',
        () {
      remoteLoadEnterpriseData.mockRemoteLoad(null);

      final error = sut.getFirebaseAndConcentradorEnterpriseParameters();

      expect(error, throwsA(DomainError.enterpriseOrUrlNotFound));
    });

    test("Should call LoadRemoteData on loadData", () async {
      await sut.getFirebaseAndConcentradorEnterpriseParameters();

      verify(() => remoteLoadEnterpriseData.load()).called(1);
    });
    test("Should change controllers with remoteEnterpriseData", () async {
      await sut.getFirebaseAndConcentradorEnterpriseParameters();

      expect(EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseName,
          sut.enterpriseNameController.text);
    });
    test("Should call loadEnterpriseConcentradorParameters", () async {
      await sut.getFirebaseAndConcentradorEnterpriseParameters();

      verify(
        () => loadEnterpriseConcentradorParameters.load(
          enterpriseId:
              EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
          concentradorUrl:
              EnterpriseDataBuilder.enterpriseDataEntity!.concentradorUrl!,
        ),
      ).called(1);
    });
    test("Should emit error if has error to load enterprise concentrador",
        () async {
      loadEnterpriseConcentradorParameters.mockLoadEnterpriseError();
      sut.validateEnterpriseInput(
        sut.enterpriseNameController.text,
        updateEnterpriseNameController: true,
      );

      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      await sut.validateApiAndGoToHomePage(
        commandEntity: commandEntity,
        homePresenter: homePresenter,
      );
    });
  });
}
