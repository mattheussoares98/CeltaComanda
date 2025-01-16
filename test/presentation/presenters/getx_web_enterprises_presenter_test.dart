import 'package:mocktail/mocktail.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';

import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  late GetxWebEnterprisesPresenter sut;

  late LoadAllEnterprisesSpy loadAllEnterprises;
  late NavigateToSpy navigateTo;
  late UpdateDeviceInformationsSpy updateDeviceInformations;
  late UpdateEnterpriseParametersSpy updateEnterpriseParameters;

  void initUseCases() {
    loadAllEnterprises = LoadAllEnterprisesSpy();
    navigateTo = NavigateToSpy();
    updateDeviceInformations = UpdateDeviceInformationsSpy();
    updateEnterpriseParameters = UpdateEnterpriseParametersSpy();
  }

  void initPresenters() {
    sut = GetxWebEnterprisesPresenter(
      loadAllEnterprises: loadAllEnterprises,
      navigateTo: navigateTo,
      updateDeviceInformations: updateDeviceInformations,
      updateEnterpriseParameters: updateEnterpriseParameters,
    );
  }

  void initEntitys() {
    EnterpriseBuilder.entity = EntityFactory.makeEnterpriseData();
  }

  void mockSuccess() {
    loadAllEnterprises.mockLoadAll([EnterpriseBuilder.entity!]);
  }

  setUp(() {
    initUseCases();
    initPresenters();
    initEntitys();
    mockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeEnterpriseData());
  });

  group("Load all enterprises", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(
          sut.enterprisesStream,
          emitsInOrder([
            null,
            [EnterpriseBuilder.entity!]
          ]));

      await sut.loadEnterprises();
    });

    test("Should emit correct values on failure", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.notFound]));
      expectLater(sut.enterprisesStream, emits(null));

      loadAllEnterprises.mockLoadAllError();

      await sut.loadEnterprises();
    });

    test("Should call load all enterprises", () async {
      await sut.loadEnterprises();

      verify(() => loadAllEnterprises.load()).called(1);
    });
  });

  group("Go to add or edit enterprise", () {
    test("Should emit correct values on success", () {
      expectLater(sut.mainErrorStream, emits(null));

      sut.goToAddOrEditEnterprise(EnterpriseBuilder.entity);
    });
    test("Should emit correct values on failure", () {
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      navigateTo.mockNavigateError();

      sut.goToAddOrEditEnterprise(EnterpriseBuilder.entity);
    });

    test("Should call navigate to with correct values", () {
      sut.goToAddOrEditEnterprise(EnterpriseBuilder.entity);

      verify(
        () => navigateTo.navigate(
          pageRoute: PageRoutes.webAddOrEditEnterprise,
        ),
      ).called(1);
    });
    test("Should update selected enterprise correctly", () {
      sut.goToAddOrEditEnterprise(EnterpriseBuilder.entity);
      expect(sut.selectedEnterprise, EnterpriseBuilder.entity);

      sut.goToAddOrEditEnterprise(null);
      expect(sut.selectedEnterprise, null);
    });
  });

  group("Update device informations", () {
    test("Should emit correct values", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      sut.goToAddOrEditEnterprise(EnterpriseBuilder.entity);
      await sut.updateDevicesData();
    });

    test("Should emit correct values on failure", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      updateDeviceInformations.mockError();

      await sut.updateDevicesData();
    });
    test("Should emit error if selected enterprise is null", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      await sut.updateDevicesData();
    });
  });

  group("Update enterprise parameters", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.updateEnterprise(
        enterpriseName: EnterpriseBuilder.entity!.enterpriseName,
        navsUrl: EnterpriseBuilder.entity!.url!,
        concentratorUrl: EnterpriseBuilder.entity!.concentradorUrl!,
        ccsUrl: EnterpriseBuilder.entity!.urlCCS!,
        enterpriseId: EnterpriseBuilder.entity!.enterpriseId!,
        daysPreloadImage: EnterpriseBuilder.entity!.waitDaysToPreloadImages,
        latestCompatibleVersion:
            EnterpriseBuilder.entity!.latestCompatibleVersion,
        serviceChargePercentage:
            EnterpriseBuilder.entity!.serviceChargePercentageOrValue,
        zoomImage: EnterpriseBuilder.entity!.zoomImage,
        useCovenant: EnterpriseBuilder.entity!.useCovenant,
      );
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      updateEnterpriseParameters.mockUpdateError();

      await sut.updateEnterprise(
        enterpriseName: EnterpriseBuilder.entity!.enterpriseName,
        navsUrl: EnterpriseBuilder.entity!.url!,
        concentratorUrl: EnterpriseBuilder.entity!.concentradorUrl!,
        ccsUrl: EnterpriseBuilder.entity!.urlCCS!,
        enterpriseId: EnterpriseBuilder.entity!.enterpriseId!,
        daysPreloadImage: EnterpriseBuilder.entity!.waitDaysToPreloadImages,
        latestCompatibleVersion:
            EnterpriseBuilder.entity!.latestCompatibleVersion,
        serviceChargePercentage:
            EnterpriseBuilder.entity!.serviceChargePercentageOrValue,
        zoomImage: EnterpriseBuilder.entity!.zoomImage,
        useCovenant: EnterpriseBuilder.entity!.useCovenant,
      );
    });

    test("Should update enterprise with correct values", () async {
      final enterprise = EnterpriseBuilder.entity!;
      sut.goToAddOrEditEnterprise(enterprise);

      await sut.updateEnterprise(
        enterpriseName: enterprise.enterpriseName,
        navsUrl: enterprise.url!,
        concentratorUrl: enterprise.concentradorUrl!,
        ccsUrl: enterprise.urlCCS!,
        enterpriseId: enterprise.enterpriseId!,
        daysPreloadImage: enterprise.waitDaysToPreloadImages,
        latestCompatibleVersion: enterprise.latestCompatibleVersion,
        serviceChargePercentage: enterprise.serviceChargePercentageOrValue,
        zoomImage: enterprise.zoomImage,
        useCovenant: enterprise.useCovenant,
      );

      var enterpriseWithCorrectValues = EntityFactory.makeEnterpriseData(
        updateMenu: enterprise.updateMenu! + 1,
        serviceChargeType: 1,
        updateDevicesInformations: enterprise.updateDevicesInformations! + 1,
        updateEnterprise: enterprise.updateEnterprise! + 1,
        serviceChargePercentageOrValue:
            enterprise.serviceChargePercentageOrValue,
        enterpriseName: enterprise.enterpriseName,
        url: enterprise.url,
        enterpriseId: enterprise.enterpriseId,
        concentradorUrl: enterprise.concentradorUrl,
        persistApp: false,
        urlCCS: enterprise.urlCCS,
        useCovenant: enterprise.useCovenant,
        enterpriseConcentradorParametersEntity:
            enterprise.enterpriseConcentradorParametersEntity,
        zoomImage: enterprise.zoomImage,
        pendingDevicesToUpdate: enterprise.pendingDevicesToUpdate,
        updatePendingDevices: enterprise.updatePendingDevices,
        waitDaysToPreloadImages: enterprise.waitDaysToPreloadImages,
        latestCompatibleVersion: enterprise.latestCompatibleVersion,
      );
      enterpriseWithCorrectValues = EntityFactory.makeEnterpriseWithNullValue(
        atualEntity: enterpriseWithCorrectValues,
        enterpriseConcentradorParametersEntity: true,
      );

      verify(() =>
              updateEnterpriseParameters.update(enterpriseWithCorrectValues))
          .called(1);
    });
    test("Should update enterprise with correct values when pass null values",
        () async {
      final enterprise = EnterpriseBuilder.entity!;
      sut.goToAddOrEditEnterprise(enterprise);

      await sut.updateEnterprise(
        enterpriseName: enterprise.enterpriseName,
        navsUrl: enterprise.url!,
        concentratorUrl: enterprise.concentradorUrl!,
        ccsUrl: enterprise.urlCCS!,
        enterpriseId: enterprise.enterpriseId!,
        daysPreloadImage: null,
        latestCompatibleVersion: null,
        serviceChargePercentage: null,
        zoomImage: null,
        useCovenant: null,
      );

      var enterpriseWithCorrectValues = EntityFactory.makeEnterpriseData(
        updateMenu: enterprise.updateMenu! + 1,
        serviceChargeType: null,
        updateDevicesInformations: enterprise.updateDevicesInformations! + 1,
        updateEnterprise: enterprise.updateEnterprise! + 1,
        persistApp: false,
        serviceChargePercentageOrValue: null,
        waitDaysToPreloadImages: null,
        latestCompatibleVersion: null,
        zoomImage: null,
        useCovenant: null,
        enterpriseName: enterprise.enterpriseName,
        url: enterprise.url,
        enterpriseId: enterprise.enterpriseId,
        concentradorUrl: enterprise.concentradorUrl,
        urlCCS: enterprise.urlCCS,
        enterpriseConcentradorParametersEntity:
            enterprise.enterpriseConcentradorParametersEntity,
        pendingDevicesToUpdate: enterprise.pendingDevicesToUpdate,
        updatePendingDevices: enterprise.updatePendingDevices,
      );
      enterpriseWithCorrectValues = EntityFactory.makeEnterpriseWithNullValue(
        atualEntity: enterpriseWithCorrectValues,
        enterpriseConcentradorParametersEntity: true,
        waitDaysToPreloadImages: true,
        latestCompatibleVersion: true,
        serviceChargePercentageOrValue: true,
        zoomImage: true,
        useCovenant: true,
        serviceChargeType: true,
      );

      verify(() =>
              updateEnterpriseParameters.update(enterpriseWithCorrectValues))
          .called(1);
    });

    test("Should return true on success", () async {
      final result = await sut.updateEnterprise(
        enterpriseName: EnterpriseBuilder.entity!.enterpriseName,
        navsUrl: EnterpriseBuilder.entity!.url!,
        concentratorUrl: EnterpriseBuilder.entity!.concentradorUrl!,
        ccsUrl: EnterpriseBuilder.entity!.urlCCS!,
        enterpriseId: EnterpriseBuilder.entity!.enterpriseId!,
        daysPreloadImage: EnterpriseBuilder.entity!.waitDaysToPreloadImages,
        latestCompatibleVersion:
            EnterpriseBuilder.entity!.latestCompatibleVersion,
        serviceChargePercentage:
            EnterpriseBuilder.entity!.serviceChargePercentageOrValue,
        zoomImage: EnterpriseBuilder.entity!.zoomImage,
        useCovenant: EnterpriseBuilder.entity!.useCovenant,
      );

      expect(result, true);
    });

    test("Should return false on error", () async {
      updateEnterpriseParameters.mockUpdateError();

      final result = await sut.updateEnterprise(
        enterpriseName: EnterpriseBuilder.entity!.enterpriseName,
        navsUrl: EnterpriseBuilder.entity!.url!,
        concentratorUrl: EnterpriseBuilder.entity!.concentradorUrl!,
        ccsUrl: EnterpriseBuilder.entity!.urlCCS!,
        enterpriseId: EnterpriseBuilder.entity!.enterpriseId!,
        daysPreloadImage: EnterpriseBuilder.entity!.waitDaysToPreloadImages,
        latestCompatibleVersion:
            EnterpriseBuilder.entity!.latestCompatibleVersion,
        serviceChargePercentage:
            EnterpriseBuilder.entity!.serviceChargePercentageOrValue,
        zoomImage: EnterpriseBuilder.entity!.zoomImage,
        useCovenant: EnterpriseBuilder.entity!.useCovenant,
      );

      expect(result, false);
    });
  });
}
