import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
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
  // ignore: unused_local_variable
  late EnterpriseEntity clearedEnterprise;

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
    );
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
    );
    await sut.goToHomePage(homePresenter);

    verify(() => persistent.makeNotPersistent()).called(1);
  });

  test("Should call loadCommandData on loadLocalData", () async {
    await sut.getLocalData(homePresenter);

    verify(() => loadCommandData.load()).called(1);
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
}
