import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
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
  late LoadEnterpriseDataSpy loadEnterpriseData;
  late NavigateToSpy navigateTo;
  late CommandInformationsSpy commandInformations;
  late LocalCommandDataSpy localCommandData;
  late PersistentSpy persistent;
  late LoadEnterpriseConcentradorParametersSpy
      loadEnterpriseConcentradorParameters;
  late PdvRegistrationSpy pdvRegistration;
  late LoadDeviceDataSpy loadDeviceData;

  late TicketIsPermittedEntity ticketIsPermittedEntity;
  late CommandEntity commandEntity;
  late EnterpriseEntity enterpriseEntity;
  late EnterpriseConcentradorParametersEntity
      enterpriseConcentradorParametersEntity;
  late EnterpriseEntity clearedEnterprise;
  late bool isFixedCommandNumber;
  late int commandNumber;
  late List<PdvEntity> pdvsNotUsing;
  late String imeiOrWindowsId;
  late String applicationVersion;

  void initUseCases() {
    validation = ValidationSpy();
    localCommandData = LocalCommandDataSpy();
    localEnterpriseData = LocalEnterpriseDataSpy();
    loadEnterpriseData = LoadEnterpriseDataSpy();
    commandInformations = CommandInformationsSpy();
    navigateTo = NavigateToSpy();
    persistent = PersistentSpy();
    loadEnterpriseConcentradorParameters =
        LoadEnterpriseConcentradorParametersSpy();
    pdvRegistration = PdvRegistrationSpy();
    loadDeviceData = LoadDeviceDataSpy();
  }

  void initPresenters() {
    homePresenter = HomePresenterSpy();

    sut = GetxEnterprisePresenter(
      validation: validation,
      localEntepriseData: localEnterpriseData,
      loadEnterpriseData: loadEnterpriseData,
      navigateTo: navigateTo,
      commandInformations: commandInformations,
      localCommandData: localCommandData,
      persistent: persistent,
      loadEnterpriseConcentradorParameters:
          loadEnterpriseConcentradorParameters,
      pdvRegistration: pdvRegistration,
      loadDeviceData: loadDeviceData,
    );
  }

  void initEntitys() {
    enterpriseEntity = EntityFactory.makeEnterpriseData();
    EnterpriseBuilder.entity = enterpriseEntity;
    ticketIsPermittedEntity = EntityFactory.makeTicketIsPermittedEntity();
    commandEntity = EntityFactory.makeCommandEntity();
    enterpriseConcentradorParametersEntity =
        EntityFactory.makeEnterpriseConcentradorParametersEntity();

    isFixedCommandNumber = faker.randomGenerator.boolean();
    commandNumber = faker.randomGenerator.integer(100);

    clearedEnterprise = EnterpriseEntity(
      enterpriseName: EnterpriseBuilder.entity?.enterpriseName ?? "",
      url: null,
      enterpriseId: null,
      concentradorUrl: null,
      persistApp: null,
      urlCCS: null,
      useCovenant: null,
      enterpriseConcentradorParametersEntity: null,
      updateMenu: null,
      updateConcentratorEnterpriseData: null,
      serviceChargePercentageOrValue: null,
      serviceChargeType: null,
      updateDevicesInformations: null,
      updateEnterprise: null,
      zoomImage: null,
      pendingDevicesToUpdate: null,
      updatePendingDevices: null,
      waitDaysToPreloadImages: null,
      secondsPreloadingImages: null,
      pluServiceCharge: null,
      internalCodeOnErpServiceCharge: null,
    );

    pdvsNotUsing = [
      EntityFactory.makePdvEntity(),
      EntityFactory.makePdvEntity(),
    ];
    applicationVersion = faker.randomGenerator.decimal().toString();
    imeiOrWindowsId = faker.guid.guid();
  }

  void mockSuccess() {
    localEnterpriseData.mockAdd(EnterpriseBuilder.entity!);
    localEnterpriseData.mockLoad(EnterpriseBuilder.entity!);
    loadEnterpriseData.mockLoad(EnterpriseBuilder.entity!);
    commandInformations.mockTicketIsPermitted(ticketIsPermittedEntity);
    localCommandData.mockUpdate();
    localCommandData.mockLoad(commandEntity);
    loadEnterpriseConcentradorParameters
        .mockLoadEnterprise(enterpriseConcentradorParametersEntity);
    pdvRegistration.mockGetPdvNotUsing(pdvsNotUsing);
    loadDeviceData.mockGetApplicationVersion(applicationVersion);
    loadDeviceData.mockGetImeiOrWindowsId(imeiOrWindowsId);
  }

  setUp(() {
    initUseCases();
    initPresenters();
    initEntitys();
    mockSuccess();
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
    registerFallbackValue(EntityFactory.makePdvEntity());
  });

  group("old tests", () {
    test(
        "Should make persist app when go to home page and enterprise.persist app is true",
        () async {
      EnterpriseBuilder.entity = EnterpriseEntity(
        enterpriseName: EnterpriseBuilder.entity!.enterpriseName,
        url: EnterpriseBuilder.entity!.url,
        enterpriseId: EnterpriseBuilder.entity!.enterpriseId,
        concentradorUrl: EnterpriseBuilder.entity!.concentradorUrl,
        persistApp: true,
        urlCCS: EnterpriseBuilder.entity!.urlCCS,
        useCovenant: EnterpriseBuilder.entity!.useCovenant,
        enterpriseConcentradorParametersEntity:
            EnterpriseBuilder.entity!.enterpriseConcentradorParametersEntity,
        updateMenu: EnterpriseBuilder.entity!.updateMenu,
        updateConcentratorEnterpriseData:
            EnterpriseBuilder.entity!.updateConcentratorEnterpriseData,
        serviceChargePercentageOrValue:
            EnterpriseBuilder.entity!.serviceChargePercentageOrValue,
        serviceChargeType: EnterpriseBuilder.entity!.serviceChargeType,
        updateEnterprise: EnterpriseBuilder.entity!.updateEnterprise,
        updateDevicesInformations:
            EnterpriseBuilder.entity!.updateDevicesInformations,
        zoomImage: EnterpriseBuilder.entity!.zoomImage,
        pendingDevicesToUpdate:
            EnterpriseBuilder.entity!.pendingDevicesToUpdate,
        updatePendingDevices: EnterpriseBuilder.entity!.updatePendingDevices,
        waitDaysToPreloadImages:
            EnterpriseBuilder.entity!.waitDaysToPreloadImages,
        secondsPreloadingImages:
            EnterpriseBuilder.entity!.secondsPreloadingImages,
        pluServiceCharge: EnterpriseBuilder.entity!.pluServiceCharge,
        internalCodeOnErpServiceCharge: EnterpriseBuilder.entity!.internalCodeOnErpServiceCharge,
      );

      await sut.validateEnterpriseByName(
        homePresenter: homePresenter,
        isFixedCommandNumber: faker.randomGenerator.boolean(),
        commandNumber:
            faker.randomGenerator.integer(100).toString().padLeft(3, "0"),
      );

      verify(() => persistent.makePersistent()).called(1);
    });
    test(
        "Should make NOT persist app when go to home page and enterprise.persist app is true and is generating version to rede",
        () async {
      EnterpriseBuilder.entity = EnterpriseEntity(
        enterpriseName: EnterpriseBuilder.entity!.enterpriseName,
        url: EnterpriseBuilder.entity!.url,
        enterpriseId: EnterpriseBuilder.entity!.enterpriseId,
        concentradorUrl: EnterpriseBuilder.entity!.concentradorUrl,
        persistApp: true,
        urlCCS: EnterpriseBuilder.entity!.urlCCS,
        useCovenant: EnterpriseBuilder.entity!.useCovenant,
        enterpriseConcentradorParametersEntity:
            EnterpriseBuilder.entity!.enterpriseConcentradorParametersEntity,
        updateMenu: EnterpriseBuilder.entity!.updateMenu,
        updateConcentratorEnterpriseData:
            EnterpriseBuilder.entity!.updateConcentratorEnterpriseData,
        serviceChargePercentageOrValue:
            EnterpriseBuilder.entity!.serviceChargePercentageOrValue,
        serviceChargeType: EnterpriseBuilder.entity!.serviceChargeType,
        updateEnterprise: EnterpriseBuilder.entity!.updateEnterprise,
        updateDevicesInformations:
            EnterpriseBuilder.entity!.updateDevicesInformations,
        zoomImage: EnterpriseBuilder.entity!.zoomImage,
        pendingDevicesToUpdate:
            EnterpriseBuilder.entity!.pendingDevicesToUpdate,
        updatePendingDevices: EnterpriseBuilder.entity!.updatePendingDevices,
        waitDaysToPreloadImages:
            EnterpriseBuilder.entity!.waitDaysToPreloadImages,
        secondsPreloadingImages:
            EnterpriseBuilder.entity!.secondsPreloadingImages,
        pluServiceCharge: EnterpriseBuilder.entity!.pluServiceCharge,
        internalCodeOnErpServiceCharge: EnterpriseBuilder.entity!.internalCodeOnErpServiceCharge,
      );
      homePresenter.isGeneratingVersionToRedeMock = true;

      await sut.validateEnterpriseByName(
        homePresenter: homePresenter,
        isFixedCommandNumber: faker.randomGenerator.boolean(),
        commandNumber:
            faker.randomGenerator.integer(100).toString().padLeft(3, "0"),
      );

      verify(() => persistent.makeNotPersistent()).called(1);
    });
    test(
        "Should make NOT persist app when go to home page and enterprise.persist app is true and is generating version to getnet",
        () async {
      EnterpriseBuilder.entity = EnterpriseEntity(
        enterpriseName: EnterpriseBuilder.entity!.enterpriseName,
        url: EnterpriseBuilder.entity!.url,
        enterpriseId: EnterpriseBuilder.entity!.enterpriseId,
        concentradorUrl: EnterpriseBuilder.entity!.concentradorUrl,
        persistApp: true,
        urlCCS: EnterpriseBuilder.entity!.urlCCS,
        useCovenant: EnterpriseBuilder.entity!.useCovenant,
        enterpriseConcentradorParametersEntity:
            EnterpriseBuilder.entity!.enterpriseConcentradorParametersEntity,
        updateMenu: EnterpriseBuilder.entity!.updateMenu,
        updateConcentratorEnterpriseData:
            EnterpriseBuilder.entity!.updateConcentratorEnterpriseData,
        serviceChargePercentageOrValue:
            EnterpriseBuilder.entity!.serviceChargePercentageOrValue,
        serviceChargeType: EnterpriseBuilder.entity!.serviceChargeType,
        updateEnterprise: EnterpriseBuilder.entity!.updateEnterprise,
        updateDevicesInformations:
            EnterpriseBuilder.entity!.updateDevicesInformations,
        zoomImage: EnterpriseBuilder.entity!.zoomImage,
        pendingDevicesToUpdate:
            EnterpriseBuilder.entity!.pendingDevicesToUpdate,
        updatePendingDevices: EnterpriseBuilder.entity!.updatePendingDevices,
        waitDaysToPreloadImages:
            EnterpriseBuilder.entity!.waitDaysToPreloadImages,
        secondsPreloadingImages:
            EnterpriseBuilder.entity!.secondsPreloadingImages,
        pluServiceCharge: EnterpriseBuilder.entity!.pluServiceCharge,
        internalCodeOnErpServiceCharge: EnterpriseBuilder.entity!.internalCodeOnErpServiceCharge,
      );
      homePresenter.isGeneratingVersionToGetNetMock = true;

      await sut.validateEnterpriseByName(
        homePresenter: homePresenter,
        isFixedCommandNumber: faker.randomGenerator.boolean(),
        commandNumber:
            faker.randomGenerator.integer(100).toString().padLeft(3, "0"),
      );

      verify(() => persistent.makeNotPersistent()).called(1);
    });
    test(
        "Should make NOT persist app when go to home page and enterprise.persist app is false",
        () async {
      EnterpriseBuilder.entity = EnterpriseEntity(
        enterpriseName: EnterpriseBuilder.entity!.enterpriseName,
        url: EnterpriseBuilder.entity!.url,
        enterpriseId: EnterpriseBuilder.entity!.enterpriseId,
        concentradorUrl: EnterpriseBuilder.entity!.concentradorUrl,
        persistApp: false,
        urlCCS: EnterpriseBuilder.entity!.urlCCS,
        useCovenant: EnterpriseBuilder.entity!.useCovenant,
        enterpriseConcentradorParametersEntity:
            EnterpriseBuilder.entity!.enterpriseConcentradorParametersEntity,
        updateMenu: EnterpriseBuilder.entity!.updateMenu,
        updateConcentratorEnterpriseData:
            EnterpriseBuilder.entity!.updateConcentratorEnterpriseData,
        serviceChargePercentageOrValue:
            EnterpriseBuilder.entity!.serviceChargePercentageOrValue,
        serviceChargeType: EnterpriseBuilder.entity!.serviceChargeType,
        updateEnterprise: EnterpriseBuilder.entity!.updateEnterprise,
        updateDevicesInformations:
            EnterpriseBuilder.entity!.updateDevicesInformations,
        zoomImage: EnterpriseBuilder.entity!.zoomImage,
        pendingDevicesToUpdate:
            EnterpriseBuilder.entity!.pendingDevicesToUpdate,
        updatePendingDevices: EnterpriseBuilder.entity!.updatePendingDevices,
        waitDaysToPreloadImages:
            EnterpriseBuilder.entity!.waitDaysToPreloadImages,
        secondsPreloadingImages:
            EnterpriseBuilder.entity!.secondsPreloadingImages,
        pluServiceCharge: EnterpriseBuilder.entity!.pluServiceCharge,
        internalCodeOnErpServiceCharge: EnterpriseBuilder.entity!.internalCodeOnErpServiceCharge,
      );

      await sut.validateEnterpriseByName(
        homePresenter: homePresenter,
        isFixedCommandNumber: faker.randomGenerator.boolean(),
        commandNumber:
            faker.randomGenerator.integer(100).toString().padLeft(3, "0"),
      );

      verify(() => persistent.makeNotPersistent()).called(1);
    });

    test("Should call loadCommandData on loadLocalData", () async {
      await sut.updateEnterpriseWithLocalData();

      verify(() => localEnterpriseData.load()).called(1);
    });

    test(
        "Should update EnterpriseDataBuilder.enterpriseName when validateEnterpriseInput",
        () async {
      String enterpriseName = faker.randomGenerator.string(20);

      sut.validateEnterpriseInput(enterpriseName);

      expect(
        EnterpriseBuilder.entity,
        EnterpriseEntity(
          enterpriseName: enterpriseName,
          url: null,
          enterpriseId: null,
          concentradorUrl: null,
          persistApp: null,
          urlCCS: null,
          useCovenant: null,
          enterpriseConcentradorParametersEntity: null,
          updateMenu: null,
          updateConcentratorEnterpriseData: null,
          serviceChargePercentageOrValue: null,
          serviceChargeType: null,
          updateDevicesInformations: null,
          updateEnterprise: null,
          zoomImage: null,
          pendingDevicesToUpdate: null,
          updatePendingDevices: null,
          waitDaysToPreloadImages: null,
          secondsPreloadingImages: null,
          pluServiceCharge: null,
          internalCodeOnErpServiceCharge: null,
        ),
      );
    });
  });

  group("Update enterprise with local data", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.updateEnterpriseWithLocalData();
    });

    test("Should update enterprise entity correctly", () async {
      final newEnterprise = EntityFactory.makeEnterpriseData();
      localEnterpriseData.mockLoad(newEnterprise);

      await sut.updateEnterpriseWithLocalData();

      expect(EnterpriseBuilder.entity, newEnterprise);
    });
  });

  group("Validate enterprise by name", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.validateEnterpriseByName(
        isFixedCommandNumber: isFixedCommandNumber,
        commandNumber: commandNumber.toString(),
        homePresenter: homePresenter,
      );
    });

    test("Should emit correct value if remote enterprise data is null",
        () async {
      EnterpriseBuilder.entity = clearedEnterprise;
      loadEnterpriseData.mockLoad(null);

      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.enterpriseOrUrlNotFound]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.validateEnterpriseByName(
        isFixedCommandNumber: isFixedCommandNumber,
        commandNumber: commandNumber.toString(),
        homePresenter: homePresenter,
      );
    });
    test("Should emit correct value if ticket is not permitted", () async {
      EnterpriseBuilder.entity = clearedEnterprise;
      commandInformations.mockErrorTicketIsPermitted();

      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.commandNotAvailable]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.validateEnterpriseByName(
        isFixedCommandNumber: isFixedCommandNumber,
        commandNumber: commandNumber.toString(),
        homePresenter: homePresenter,
      );
    });
    test("Should emit correct values dont have liberated pdvs to registration",
        () async {
      EnterpriseBuilder.entity = clearedEnterprise;
      homePresenter.isGeneratingVersionToGetNetMock = true;
      pdvRegistration.mockGetPdvNotUsingError(DomainError.dontHaveUnusedPdvs);

      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.dontHaveUnusedPdvs]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.validateEnterpriseByName(
        isFixedCommandNumber: isFixedCommandNumber,
        commandNumber: commandNumber.toString(),
        homePresenter: homePresenter,
      );
    });

    test("Should call load enterprise data if url is null", () async {
      EnterpriseBuilder.entity = clearedEnterprise;

      await sut.validateEnterpriseByName(
        isFixedCommandNumber: isFixedCommandNumber,
        commandNumber: commandNumber.toString(),
        homePresenter: homePresenter,
      );

      verify(() => loadEnterpriseData.load()).called(1);
    });

    test("Should load enterprise concentrator parameters with correct values",
        () async {
      EnterpriseBuilder.entity = clearedEnterprise;

      await sut.validateEnterpriseByName(
        isFixedCommandNumber: isFixedCommandNumber,
        commandNumber: commandNumber.toString(),
        homePresenter: homePresenter,
      );

      verify(() => loadEnterpriseConcentradorParameters.load(
            enterpriseId: EnterpriseBuilder.entity!.enterpriseId!,
            concentradorUrl: EnterpriseBuilder.entity!.concentradorUrl!,
          )).called(1);
    });
    test("Should update enterprise correctly", () async {
      EnterpriseBuilder.entity = clearedEnterprise;
      final newEnterprise = EntityFactory.makeEnterpriseData();
      final newConcentratorEnterprise =
          EntityFactory.makeEnterpriseConcentradorParametersEntity();
      loadEnterpriseData.mockLoad(newEnterprise);
      loadEnterpriseConcentradorParameters
          .mockLoadEnterprise(newConcentratorEnterprise);

      await sut.validateEnterpriseByName(
        isFixedCommandNumber: isFixedCommandNumber,
        commandNumber: commandNumber.toString(),
        homePresenter: homePresenter,
      );

      expect(
        EnterpriseBuilder.entity,
        EnterpriseEntity(
          enterpriseName: newEnterprise.enterpriseName,
          url: newEnterprise.url,
          enterpriseId: newEnterprise.enterpriseId,
          concentradorUrl: newEnterprise.concentradorUrl,
          persistApp: newEnterprise.persistApp,
          urlCCS: newEnterprise.urlCCS,
          useCovenant: newEnterprise.useCovenant,
          updateMenu: newEnterprise.updateMenu,
          updateConcentratorEnterpriseData:
              newEnterprise.updateConcentratorEnterpriseData,
          serviceChargePercentageOrValue:
              newEnterprise.serviceChargePercentageOrValue,
          serviceChargeType: newEnterprise.serviceChargeType,
          updateDevicesInformations: newEnterprise.updateDevicesInformations,
          updateEnterprise: newEnterprise.updateEnterprise,
          zoomImage: newEnterprise.zoomImage,
          pendingDevicesToUpdate: newEnterprise.pendingDevicesToUpdate,
          updatePendingDevices: newEnterprise.updatePendingDevices,
          waitDaysToPreloadImages: newEnterprise.waitDaysToPreloadImages,
          secondsPreloadingImages: newEnterprise.secondsPreloadingImages,
          enterpriseConcentradorParametersEntity: newConcentratorEnterprise,
          pluServiceCharge: newEnterprise.pluServiceCharge,
          internalCodeOnErpServiceCharge: newEnterprise.internalCodeOnErpServiceCharge,
        ),
      );
    });

    test("Should add enterprise locally correctly", () async {
      EnterpriseBuilder.entity = clearedEnterprise;

      await sut.validateEnterpriseByName(
        isFixedCommandNumber: isFixedCommandNumber,
        commandNumber: commandNumber.toString(),
        homePresenter: homePresenter,
      );

      verify(
        () => localEnterpriseData.add(EnterpriseBuilder.entity!),
      ).called(1);
    });

    test(
        "Should verify ticket is permitted with 001 when command is null or empty",
        () async {
      EnterpriseBuilder.entity = clearedEnterprise;
      await sut.validateEnterpriseByName(
        isFixedCommandNumber: isFixedCommandNumber,
        commandNumber: null,
        homePresenter: homePresenter,
      );
      verify(() => commandInformations.ticketIsPermitted(
            url: EnterpriseBuilder.entity!.url!,
            commandNumber: "001",
          )).called(1);

      EnterpriseBuilder.entity = clearedEnterprise;
      await sut.validateEnterpriseByName(
        isFixedCommandNumber: isFixedCommandNumber,
        commandNumber: "",
        homePresenter: homePresenter,
      );
      verify(() => commandInformations.ticketIsPermitted(
            url: EnterpriseBuilder.entity!.url!,
            commandNumber: "001",
          )).called(1);
    });

    test("Should verify ticket is permitted with correct command number",
        () async {
      EnterpriseBuilder.entity = clearedEnterprise;

      final commandNumber = faker.randomGenerator.integer(100);
      await sut.validateEnterpriseByName(
        isFixedCommandNumber: isFixedCommandNumber,
        commandNumber: commandNumber.toString(),
        homePresenter: homePresenter,
      );
      verify(() => commandInformations.ticketIsPermitted(
            url: EnterpriseBuilder.entity!.url!,
            commandNumber: commandNumber.toString().padLeft(3, "0"),
          )).called(1);
    });
    test(
        "Should update local command data with null value if command is null or empty",
        () async {
      EnterpriseBuilder.entity = clearedEnterprise;
      await sut.validateEnterpriseByName(
        isFixedCommandNumber: isFixedCommandNumber,
        commandNumber: null,
        homePresenter: homePresenter,
      );
      verify(() => localCommandData.update(
            CommandEntity(
              commandNumber: null,
              isFixedCommandNumber: isFixedCommandNumber,
              pdv: null,
            ),
          )).called(1);

      EnterpriseBuilder.entity = clearedEnterprise;
      await sut.validateEnterpriseByName(
        isFixedCommandNumber: isFixedCommandNumber,
        commandNumber: "",
        homePresenter: homePresenter,
      );
      verify(() => localCommandData.update(
            CommandEntity(
              commandNumber: null,
              isFixedCommandNumber: isFixedCommandNumber,
              pdv: null,
            ),
          )).called(1);
    });

    test("Should update local command data with correct values", () async {
      EnterpriseBuilder.entity = clearedEnterprise;

      final commandNumber = faker.randomGenerator.integer(100);
      await sut.validateEnterpriseByName(
        isFixedCommandNumber: isFixedCommandNumber,
        commandNumber: commandNumber.toString(),
        homePresenter: homePresenter,
      );
      verify(() => localCommandData.update(
            CommandEntity(
              commandNumber: commandNumber.toString().padLeft(3, "0"),
              isFixedCommandNumber: isFixedCommandNumber,
              pdv: null,
            ),
          )).called(1);
    });

    test("Should navigate to home page in success", () async {
      EnterpriseBuilder.entity = clearedEnterprise;

      await sut.validateEnterpriseByName(
        isFixedCommandNumber: isFixedCommandNumber,
        commandNumber: commandNumber.toString(),
        homePresenter: homePresenter,
      );

      verify(() => navigateTo.navigate(pageRoute: PageRoutes.home, clear: true))
          .called(1);
    });

    test(
        "Should get pdvs not using when is generating version to rede or getnet",
        () async {
      EnterpriseBuilder.entity = clearedEnterprise;
      homePresenter.isGeneratingVersionToGetNetMock = true;
      await sut.validateEnterpriseByName(
        isFixedCommandNumber: isFixedCommandNumber,
        commandNumber: commandNumber.toString(),
        homePresenter: homePresenter,
      );
      verify(() => pdvRegistration.getPdvNotUsing()).called(1);

      EnterpriseBuilder.entity = clearedEnterprise;
      homePresenter.isGeneratingVersionToRedeMock = true;
      await sut.validateEnterpriseByName(
        isFixedCommandNumber: isFixedCommandNumber,
        commandNumber: commandNumber.toString(),
        homePresenter: homePresenter,
      );
      verify(() => pdvRegistration.getPdvNotUsing()).called(1);
    });

    test(
        "Should not get pdv not using when dont is generating version to rede or getnet",
        () async {
      EnterpriseBuilder.entity = clearedEnterprise;
      homePresenter.isGeneratingVersionToGetNetMock = false;
      await sut.validateEnterpriseByName(
        isFixedCommandNumber: isFixedCommandNumber,
        commandNumber: commandNumber.toString(),
        homePresenter: homePresenter,
      );
      verifyNever(() => pdvRegistration.getPdvNotUsing());

      EnterpriseBuilder.entity = clearedEnterprise;
      homePresenter.isGeneratingVersionToRedeMock = false;
      await sut.validateEnterpriseByName(
        isFixedCommandNumber: isFixedCommandNumber,
        commandNumber: commandNumber.toString(),
        homePresenter: homePresenter,
      );
      verifyNever(() => pdvRegistration.getPdvNotUsing());
    });
    test("Should emit correct values on enterprises not using", () async {
      EnterpriseBuilder.entity = clearedEnterprise;
      homePresenter.isGeneratingVersionToRedeMock = true;

      expectLater(
        sut.pdvsNotUsingStream,
        emits(
          pdvsNotUsing.map((e) => PdvNotUsingViewModel.fromEntity(e)).toList(),
        ),
      );

      await sut.validateEnterpriseByName(
        isFixedCommandNumber: isFixedCommandNumber,
        commandNumber: commandNumber.toString(),
        homePresenter: homePresenter,
      );
    });
  });

  group("Validate enterprise input", () {
    test("Should clear enterprise data, except enterprise name", () {
      final enterpriseName = faker.person.name();
      sut.validateEnterpriseInput(enterpriseName);

      expect(
          EnterpriseBuilder.entity,
          EnterpriseEntity(
            enterpriseName: enterpriseName,
            url: null,
            enterpriseId: null,
            concentradorUrl: null,
            persistApp: null,
            urlCCS: null,
            useCovenant: null,
            updateMenu: null,
            enterpriseConcentradorParametersEntity: null,
            updateConcentratorEnterpriseData: null,
            serviceChargePercentageOrValue: null,
            serviceChargeType: null,
            updateDevicesInformations: null,
            updateEnterprise: null,
            zoomImage: null,
            pendingDevicesToUpdate: null,
            updatePendingDevices: null,
            waitDaysToPreloadImages: null,
            secondsPreloadingImages: null,
            pluServiceCharge: null,
            internalCodeOnErpServiceCharge: null,
          ));
    });
  });

  group("Update concentrator enterprise parameters", () {
    test("Should call loadEnterpriseConcentradorParameters with correct values",
        () async {
      await sut.updateConcentratorEnterpriseParameters();

      verify(() => loadEnterpriseConcentradorParameters.load(
            enterpriseId: EnterpriseBuilder.entity!.enterpriseId!,
            concentradorUrl: EnterpriseBuilder.entity!.concentradorUrl!,
          )).called(1);
    });
    test("Should update enterprise correctly", () async {
      final newConcentratorEnterpriseParameters =
          EntityFactory.makeEnterpriseConcentradorParametersEntity();
      loadEnterpriseConcentradorParameters
          .mockLoadEnterprise(newConcentratorEnterpriseParameters);

      await sut.updateConcentratorEnterpriseParameters();

      expect(
          EnterpriseBuilder.entity,
          EnterpriseEntity(
            enterpriseConcentradorParametersEntity:
                newConcentratorEnterpriseParameters,
            enterpriseName: EnterpriseBuilder.entity!.enterpriseName,
            url: EnterpriseBuilder.entity!.url,
            enterpriseId: EnterpriseBuilder.entity!.enterpriseId,
            concentradorUrl: EnterpriseBuilder.entity!.concentradorUrl,
            persistApp: EnterpriseBuilder.entity!.persistApp,
            urlCCS: EnterpriseBuilder.entity!.urlCCS,
            useCovenant: EnterpriseBuilder.entity!.useCovenant,
            updateMenu: EnterpriseBuilder.entity!.updateMenu,
            updateConcentratorEnterpriseData:
                EnterpriseBuilder.entity!.updateConcentratorEnterpriseData,
            serviceChargePercentageOrValue:
                EnterpriseBuilder.entity!.serviceChargePercentageOrValue,
            serviceChargeType: EnterpriseBuilder.entity!.serviceChargeType,
            updateDevicesInformations:
                EnterpriseBuilder.entity!.updateDevicesInformations,
            updateEnterprise: EnterpriseBuilder.entity!.updateEnterprise,
            zoomImage: EnterpriseBuilder.entity!.zoomImage,
            pendingDevicesToUpdate:
                EnterpriseBuilder.entity!.pendingDevicesToUpdate,
            updatePendingDevices:
                EnterpriseBuilder.entity!.updatePendingDevices,
            waitDaysToPreloadImages:
                EnterpriseBuilder.entity!.waitDaysToPreloadImages,
            secondsPreloadingImages:
                EnterpriseBuilder.entity!.secondsPreloadingImages,
            pluServiceCharge: EnterpriseBuilder.entity!.pluServiceCharge,
            internalCodeOnErpServiceCharge: EnterpriseBuilder.entity!.internalCodeOnErpServiceCharge,
          ));
    });
  });

  group("Clear enterprise data", () {
    test("Should clear enterprise, except enterprise name", () {
      sut.clearEnterpriseData();

      expect(
        EnterpriseBuilder.entity,
        EnterpriseEntity(
          enterpriseName: EnterpriseBuilder.entity!.enterpriseName,
          url: null,
          enterpriseId: null,
          concentradorUrl: null,
          persistApp: null,
          urlCCS: null,
          useCovenant: null,
          enterpriseConcentradorParametersEntity: null,
          updateMenu: null,
          updateConcentratorEnterpriseData: null,
          serviceChargePercentageOrValue: null,
          serviceChargeType: null,
          updateDevicesInformations: null,
          updateEnterprise: null,
          zoomImage: null,
          pendingDevicesToUpdate: null,
          updatePendingDevices: null,
          waitDaysToPreloadImages: null,
          secondsPreloadingImages: null,
          pluServiceCharge: null,
          internalCodeOnErpServiceCharge: null,
        ),
      );
    });
  });

  group("Update selected pdv", () {
    test("Should update selected pdv correctly", () {
      final first =
          PdvNotUsingViewModel.fromEntity(EntityFactory.makePdvEntity());
      final second =
          PdvNotUsingViewModel.fromEntity(EntityFactory.makePdvEntity());
      final third =
          PdvNotUsingViewModel.fromEntity(EntityFactory.makePdvEntity());

      expectLater(sut.selectedPdvStream, emitsInOrder([first, second, third]));

      sut.updateSelectedPdv(first);
      sut.updateSelectedPdv(second);
      sut.updateSelectedPdv(third);
      sut.updateSelectedPdv(third);
    });
  });

  group("Register PDV and go to home page", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      final selectedPdv = PdvNotUsingViewModel.fromEntity(pdvsNotUsing[0]);
      await sut.registerPdvAndGoToHomePage(
        selectedPdv: selectedPdv,
        commandNumber: commandNumber.toString(),
        isFixedCommandNumber: isFixedCommandNumber,
      );
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      loadDeviceData.mockGetImeiError();

      final selectedPdv = PdvNotUsingViewModel.fromEntity(pdvsNotUsing[0]);
      await sut.registerPdvAndGoToHomePage(
        selectedPdv: selectedPdv,
        commandNumber: commandNumber.toString(),
        isFixedCommandNumber: isFixedCommandNumber,
      );
    });
    test("Should call get imei or windows id", () async {
      final selectedPdv = PdvNotUsingViewModel.fromEntity(pdvsNotUsing[0]);
      await sut.registerPdvAndGoToHomePage(
        selectedPdv: selectedPdv,
        commandNumber: commandNumber.toString(),
        isFixedCommandNumber: isFixedCommandNumber,
      );

      verify(() => loadDeviceData.getImeiOrWindowsId()).called(1);
    });
    test("Should call get application version", () async {
      final selectedPdv = PdvNotUsingViewModel.fromEntity(pdvsNotUsing[0]);
      await sut.registerPdvAndGoToHomePage(
        selectedPdv: selectedPdv,
        commandNumber: commandNumber.toString(),
        isFixedCommandNumber: isFixedCommandNumber,
      );

      verify(() => loadDeviceData.getApplicationVersion()).called(1);
    });

    test("Should call set pdv register with correct values", () async {
      final selectedPdv = PdvNotUsingViewModel.fromEntity(pdvsNotUsing[0]);
      await sut.registerPdvAndGoToHomePage(
        selectedPdv: selectedPdv,
        commandNumber: commandNumber.toString(),
        isFixedCommandNumber: isFixedCommandNumber,
      );

      verify(() => pdvRegistration.setPdvRegister(
            pdvId: selectedPdv.PdvId.toInt(),
            imeiOrWindowsId: imeiOrWindowsId,
            versionNumber: applicationVersion,
            ip: "127.0.0.1",
            isUsing: true,
          )).called(1);
    });
    test("Should call navigate to home page", () async {
      final selectedPdv = PdvNotUsingViewModel.fromEntity(pdvsNotUsing[0]);
      await sut.registerPdvAndGoToHomePage(
        selectedPdv: selectedPdv,
        commandNumber: commandNumber.toString(),
        isFixedCommandNumber: isFixedCommandNumber,
      );

      verify(() => navigateTo.navigate(
            pageRoute: PageRoutes.home,
            clear: true,
          )).called(1);
    });
    test("Should update local command data correctly", () async {
      final selectedPdv = PdvNotUsingViewModel.fromEntity(pdvsNotUsing[0]);
      await sut.registerPdvAndGoToHomePage(
        selectedPdv: selectedPdv,
        commandNumber: commandNumber.toString(),
        isFixedCommandNumber: isFixedCommandNumber,
      );

      verify(() => localCommandData.update(
            CommandEntity(
              commandNumber: commandNumber.toString().padLeft(3, "0"),
              isFixedCommandNumber: isFixedCommandNumber,
              pdv: selectedPdv.toEntity(),
            ),
          )).called(1);
    });
  });
}
