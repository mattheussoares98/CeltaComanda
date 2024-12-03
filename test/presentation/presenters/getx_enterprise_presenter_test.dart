import 'package:clean_celta_mobile/domain/entities/entities.dart';
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

  late TicketIsPermittedEntity ticketIsPermittedEntity;
  late CommandEntity commandEntity;
  late EnterpriseEntity enterpriseEntity;
  late EnterpriseConcentradorParametersEntity
      enterpriseConcentradorParametersEntity;
  late EnterpriseEntity clearedEnterprise;
  late bool isFixedCommandNumber;
  late int commandNumber;
  late List<PdvEntity>? pdvsNotUsing;

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
    );
  }

  void initEntitys() {
    enterpriseEntity = EntityFactory.makeEnterpriseData();
    EnterpriseDataBuilder.enterpriseDataEntity = enterpriseEntity;
    ticketIsPermittedEntity = EntityFactory.makeTicketIsPermittedEntity();
    commandEntity = EntityFactory.makeCommandEntity();
    enterpriseConcentradorParametersEntity =
        EntityFactory.makeEnterpriseConcentradorParametersEntity();

    isFixedCommandNumber = faker.randomGenerator.boolean();
    commandNumber = faker.randomGenerator.integer(100);

    clearedEnterprise = EnterpriseEntity(
      enterpriseName:
          EnterpriseDataBuilder.enterpriseDataEntity?.enterpriseName ?? "",
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
    );

    pdvsNotUsing = [
      EntityFactory.makePdvEntity(),
      EntityFactory.makePdvEntity(),
    ];
  }

  void mockSuccess() {
    localEnterpriseData.mockAdd(EnterpriseDataBuilder.enterpriseDataEntity!);
    localEnterpriseData.mockLoad(EnterpriseDataBuilder.enterpriseDataEntity!);
    loadEnterpriseData.mockLoad(EnterpriseDataBuilder.enterpriseDataEntity!);
    commandInformations.mockTicketIsPermitted(ticketIsPermittedEntity);
    localCommandData.mockUpdate();
    localCommandData.mockLoad(commandEntity);
    loadEnterpriseConcentradorParameters
        .mockLoadEnterprise(enterpriseConcentradorParametersEntity);
    pdvRegistration.mockGetPdvNotUsing(pdvsNotUsing);
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
      updateMenu: EnterpriseDataBuilder.enterpriseDataEntity!.updateMenu,
      updateConcentratorEnterpriseData: EnterpriseDataBuilder
          .enterpriseDataEntity!.updateConcentratorEnterpriseData,
      serviceChargePercentageOrValue: EnterpriseDataBuilder
          .enterpriseDataEntity!.serviceChargePercentageOrValue,
      serviceChargeType:
          EnterpriseDataBuilder.enterpriseDataEntity!.serviceChargeType,
      updateEnterprise:
          EnterpriseDataBuilder.enterpriseDataEntity!.updateEnterprise,
      updateDevicesInformations:
          EnterpriseDataBuilder.enterpriseDataEntity!.updateDevicesInformations,
      zoomImage: EnterpriseDataBuilder.enterpriseDataEntity!.zoomImage,
      pendingDevicesToUpdate:
          EnterpriseDataBuilder.enterpriseDataEntity!.pendingDevicesToUpdate,
      updatePendingDevices:
          EnterpriseDataBuilder.enterpriseDataEntity!.updatePendingDevices,
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
      updateMenu: EnterpriseDataBuilder.enterpriseDataEntity!.updateMenu,
      updateConcentratorEnterpriseData: EnterpriseDataBuilder
          .enterpriseDataEntity!.updateConcentratorEnterpriseData,
      serviceChargePercentageOrValue: EnterpriseDataBuilder
          .enterpriseDataEntity!.serviceChargePercentageOrValue,
      serviceChargeType:
          EnterpriseDataBuilder.enterpriseDataEntity!.serviceChargeType,
      updateEnterprise:
          EnterpriseDataBuilder.enterpriseDataEntity!.updateEnterprise,
      updateDevicesInformations:
          EnterpriseDataBuilder.enterpriseDataEntity!.updateDevicesInformations,
      zoomImage: EnterpriseDataBuilder.enterpriseDataEntity!.zoomImage,
      pendingDevicesToUpdate:
          EnterpriseDataBuilder.enterpriseDataEntity!.pendingDevicesToUpdate,
      updatePendingDevices:
          EnterpriseDataBuilder.enterpriseDataEntity!.updatePendingDevices,
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
      updateMenu: EnterpriseDataBuilder.enterpriseDataEntity!.updateMenu,
      updateConcentratorEnterpriseData: EnterpriseDataBuilder
          .enterpriseDataEntity!.updateConcentratorEnterpriseData,
      serviceChargePercentageOrValue: EnterpriseDataBuilder
          .enterpriseDataEntity!.serviceChargePercentageOrValue,
      serviceChargeType:
          EnterpriseDataBuilder.enterpriseDataEntity!.serviceChargeType,
      updateEnterprise:
          EnterpriseDataBuilder.enterpriseDataEntity!.updateEnterprise,
      updateDevicesInformations:
          EnterpriseDataBuilder.enterpriseDataEntity!.updateDevicesInformations,
      zoomImage: EnterpriseDataBuilder.enterpriseDataEntity!.zoomImage,
      pendingDevicesToUpdate:
          EnterpriseDataBuilder.enterpriseDataEntity!.pendingDevicesToUpdate,
      updatePendingDevices:
          EnterpriseDataBuilder.enterpriseDataEntity!.updatePendingDevices,
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
      updateMenu: EnterpriseDataBuilder.enterpriseDataEntity!.updateMenu,
      updateConcentratorEnterpriseData: EnterpriseDataBuilder
          .enterpriseDataEntity!.updateConcentratorEnterpriseData,
      serviceChargePercentageOrValue: EnterpriseDataBuilder
          .enterpriseDataEntity!.serviceChargePercentageOrValue,
      serviceChargeType:
          EnterpriseDataBuilder.enterpriseDataEntity!.serviceChargeType,
      updateEnterprise:
          EnterpriseDataBuilder.enterpriseDataEntity!.updateEnterprise,
      updateDevicesInformations:
          EnterpriseDataBuilder.enterpriseDataEntity!.updateDevicesInformations,
      zoomImage: EnterpriseDataBuilder.enterpriseDataEntity!.zoomImage,
      pendingDevicesToUpdate:
          EnterpriseDataBuilder.enterpriseDataEntity!.pendingDevicesToUpdate,
      updatePendingDevices:
          EnterpriseDataBuilder.enterpriseDataEntity!.updatePendingDevices,
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
        updateMenu: null,
        updateConcentratorEnterpriseData: null,
        serviceChargePercentageOrValue: null,
        serviceChargeType: null,
        updateDevicesInformations: null,
        updateEnterprise: null,
        zoomImage: null,
        pendingDevicesToUpdate: null,
        updatePendingDevices: null,
      ),
    );
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

      expect(EnterpriseDataBuilder.enterpriseDataEntity, newEnterprise);
    });
  });

  group("Validate enterprise and go to home page", () {
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
      EnterpriseDataBuilder.enterpriseDataEntity = clearedEnterprise;
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
      EnterpriseDataBuilder.enterpriseDataEntity = clearedEnterprise;
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

    test("Should call load enterprise data if url is null", () async {
      EnterpriseDataBuilder.enterpriseDataEntity = clearedEnterprise;

      await sut.validateEnterpriseByName(
        isFixedCommandNumber: isFixedCommandNumber,
        commandNumber: commandNumber.toString(),
        homePresenter: homePresenter,
      );

      verify(() => loadEnterpriseData.load()).called(1);
    });

    test("Should load enterprise concentrator parameters with correct values",
        () async {
      EnterpriseDataBuilder.enterpriseDataEntity = clearedEnterprise;

      await sut.validateEnterpriseByName(
        isFixedCommandNumber: isFixedCommandNumber,
        commandNumber: commandNumber.toString(),
        homePresenter: homePresenter,
      );

      verify(() => loadEnterpriseConcentradorParameters.load(
            enterpriseId:
                EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
            concentradorUrl:
                EnterpriseDataBuilder.enterpriseDataEntity!.concentradorUrl!,
          )).called(1);
    });
    test("Should update enterprise correctly", () async {
      EnterpriseDataBuilder.enterpriseDataEntity = clearedEnterprise;
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
        EnterpriseDataBuilder.enterpriseDataEntity,
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
          enterpriseConcentradorParametersEntity: newConcentratorEnterprise,
        ),
      );
    });

    test("Should add enterprise locally correctly", () async {
      EnterpriseDataBuilder.enterpriseDataEntity = clearedEnterprise;

      await sut.validateEnterpriseByName(
        isFixedCommandNumber: isFixedCommandNumber,
        commandNumber: commandNumber.toString(),
        homePresenter: homePresenter,
      );

      verify(
        () => localEnterpriseData
            .add(EnterpriseDataBuilder.enterpriseDataEntity!),
      ).called(1);
    });

    test(
        "Should verify ticket is permitted with 001 when command is null or empty",
        () async {
      EnterpriseDataBuilder.enterpriseDataEntity = clearedEnterprise;
      await sut.validateEnterpriseByName(
        isFixedCommandNumber: isFixedCommandNumber,
        commandNumber: null,
        homePresenter: homePresenter,
      );
      verify(() => commandInformations.ticketIsPermitted(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            commandNumber: "001",
          )).called(1);

      EnterpriseDataBuilder.enterpriseDataEntity = clearedEnterprise;
      await sut.validateEnterpriseByName(
        isFixedCommandNumber: isFixedCommandNumber,
        commandNumber: "",
        homePresenter: homePresenter,
      );
      verify(() => commandInformations.ticketIsPermitted(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            commandNumber: "001",
          )).called(1);
    });

    test("Should verify ticket is permitted with correct command number",
        () async {
      EnterpriseDataBuilder.enterpriseDataEntity = clearedEnterprise;

      final commandNumber = faker.randomGenerator.integer(100);
      await sut.validateEnterpriseByName(
        isFixedCommandNumber: isFixedCommandNumber,
        commandNumber: commandNumber.toString(),
        homePresenter: homePresenter,
      );
      verify(() => commandInformations.ticketIsPermitted(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            commandNumber: commandNumber.toString().padLeft(3, "0"),
          )).called(1);
    });
    test(
        "Should update local command data with null value if command is null or empty",
        () async {
      EnterpriseDataBuilder.enterpriseDataEntity = clearedEnterprise;
      await sut.validateEnterpriseByName(
        isFixedCommandNumber: isFixedCommandNumber,
        commandNumber: null,
        homePresenter: homePresenter,
      );
      verify(() => localCommandData.update(
            CommandEntity(
              commandNumber: null,
              isFixedCommandNumber: isFixedCommandNumber,
            ),
          )).called(1);

      EnterpriseDataBuilder.enterpriseDataEntity = clearedEnterprise;
      await sut.validateEnterpriseByName(
        isFixedCommandNumber: isFixedCommandNumber,
        commandNumber: "",
        homePresenter: homePresenter,
      );
      verify(() => localCommandData.update(
            CommandEntity(
              commandNumber: null,
              isFixedCommandNumber: isFixedCommandNumber,
            ),
          )).called(1);
    });

    test("Should update local command data with correct values", () async {
      EnterpriseDataBuilder.enterpriseDataEntity = clearedEnterprise;

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
            ),
          )).called(1);
    });

    test("Should navigate to home page in success", () async {
      EnterpriseDataBuilder.enterpriseDataEntity = clearedEnterprise;

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
      EnterpriseDataBuilder.enterpriseDataEntity = clearedEnterprise;
      homePresenter.isGeneratingVersionToGetNetMock = true;
      await sut.validateEnterpriseByName(
        isFixedCommandNumber: isFixedCommandNumber,
        commandNumber: commandNumber.toString(),
        homePresenter: homePresenter,
      );
      verify(() => pdvRegistration.getPdvNotUsing()).called(1);

      EnterpriseDataBuilder.enterpriseDataEntity = clearedEnterprise;
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
      EnterpriseDataBuilder.enterpriseDataEntity = clearedEnterprise;
      homePresenter.isGeneratingVersionToGetNetMock = false;
      await sut.validateEnterpriseByName(
        isFixedCommandNumber: isFixedCommandNumber,
        commandNumber: commandNumber.toString(),
        homePresenter: homePresenter,
      );
      verifyNever(() => pdvRegistration.getPdvNotUsing());

      EnterpriseDataBuilder.enterpriseDataEntity = clearedEnterprise;
      homePresenter.isGeneratingVersionToRedeMock = false;
      await sut.validateEnterpriseByName(
        isFixedCommandNumber: isFixedCommandNumber,
        commandNumber: commandNumber.toString(),
        homePresenter: homePresenter,
      );
      verifyNever(() => pdvRegistration.getPdvNotUsing());
    });
    test("Should emit correct values on enterprises not using", () async {
      EnterpriseDataBuilder.enterpriseDataEntity = clearedEnterprise;
      homePresenter.isGeneratingVersionToRedeMock = true;

      expectLater(
        sut.pdvsNotUsingStream,
        emits(
          pdvsNotUsing?.map((e) => PdvNotUsingViewModel.fromEntity(e)).toList(),
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
          EnterpriseDataBuilder.enterpriseDataEntity,
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
          ));
    });
  });

  group("Update concentrator enterprise parameters", () {
    test("Should call loadEnterpriseConcentradorParameters with correct values",
        () async {
      await sut.updateConcentratorEnterpriseParameters();

      verify(() => loadEnterpriseConcentradorParameters.load(
            enterpriseId:
                EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
            concentradorUrl:
                EnterpriseDataBuilder.enterpriseDataEntity!.concentradorUrl!,
          )).called(1);
    });
    test("Should update enterprise correctly", () async {
      final newConcentratorEnterpriseParameters =
          EntityFactory.makeEnterpriseConcentradorParametersEntity();
      loadEnterpriseConcentradorParameters
          .mockLoadEnterprise(newConcentratorEnterpriseParameters);

      await sut.updateConcentratorEnterpriseParameters();

      expect(
          EnterpriseDataBuilder.enterpriseDataEntity,
          EnterpriseEntity(
            enterpriseConcentradorParametersEntity:
                newConcentratorEnterpriseParameters,
            enterpriseName:
                EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseName,
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url,
            enterpriseId:
                EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId,
            concentradorUrl:
                EnterpriseDataBuilder.enterpriseDataEntity!.concentradorUrl,
            persistApp: EnterpriseDataBuilder.enterpriseDataEntity!.persistApp,
            urlCCS: EnterpriseDataBuilder.enterpriseDataEntity!.urlCCS,
            useCovenant:
                EnterpriseDataBuilder.enterpriseDataEntity!.useCovenant,
            updateMenu: EnterpriseDataBuilder.enterpriseDataEntity!.updateMenu,
            updateConcentratorEnterpriseData: EnterpriseDataBuilder
                .enterpriseDataEntity!.updateConcentratorEnterpriseData,
            serviceChargePercentageOrValue: EnterpriseDataBuilder
                .enterpriseDataEntity!.serviceChargePercentageOrValue,
            serviceChargeType:
                EnterpriseDataBuilder.enterpriseDataEntity!.serviceChargeType,
            updateDevicesInformations: EnterpriseDataBuilder
                .enterpriseDataEntity!.updateDevicesInformations,
            updateEnterprise:
                EnterpriseDataBuilder.enterpriseDataEntity!.updateEnterprise,
            zoomImage: EnterpriseDataBuilder.enterpriseDataEntity!.zoomImage,
            pendingDevicesToUpdate: EnterpriseDataBuilder
                .enterpriseDataEntity!.pendingDevicesToUpdate,
            updatePendingDevices: EnterpriseDataBuilder
                .enterpriseDataEntity!.updatePendingDevices,
          ));
    });
  });

  group("Clear enterprise data", () {
    test("Should clear enterprise, except enterprise name", () {
      sut.clearEnterpriseData();

      expect(
        EnterpriseDataBuilder.enterpriseDataEntity,
        EnterpriseEntity(
          enterpriseName:
              EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseName,
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
        ),
      );
    });
  });
}
