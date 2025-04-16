import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
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
  late DeleteEnterpriseSpy deleteEnterprise;
  late LoadDevicesInfoSpy loadDevicesInfo;

  late List<DeviceInfoViewModel> devices;

  void initUseCases() {
    loadAllEnterprises = LoadAllEnterprisesSpy();
    navigateTo = NavigateToSpy();
    updateDeviceInformations = UpdateDeviceInformationsSpy();
    updateEnterpriseParameters = UpdateEnterpriseParametersSpy();
    deleteEnterprise = DeleteEnterpriseSpy();
    loadDevicesInfo = LoadDevicesInfoSpy();
  }

  void initPresenters() {
    sut = GetxWebEnterprisesPresenter(
      loadAllEnterprises: loadAllEnterprises,
      navigateTo: navigateTo,
      updateDeviceInformations: updateDeviceInformations,
      updateEnterpriseParameters: updateEnterpriseParameters,
      deleteEnterprise: deleteEnterprise,
      loadDevicesInfo: loadDevicesInfo,
    );
  }

  void initEntitys() {
    EnterpriseBuilder.entity = EntityFactory.makeEnterpriseData();
    devices = [
      DeviceInfoViewModel.fromEntity(EntityFactory.makeDeviceInfoEntity()),
      DeviceInfoViewModel.fromEntity(EntityFactory.makeDeviceInfoEntity()),
    ];
  }

  void mockSuccess() {
    loadAllEnterprises.mockLoadAll([EnterpriseBuilder.entity!]);
    loadDevicesInfo.mockLoad(devices.map((e) => e.toEntity()).toList());
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

      await sut.updateEnterprise(EnterpriseBuilder.entity!);
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      updateEnterpriseParameters.mockUpdateError();

      await sut.updateEnterprise(EnterpriseBuilder.entity!);
    });

    test("Should update enterprise with correct values", () async {
      final enterprise = EnterpriseBuilder.entity!;
      sut.goToAddOrEditEnterprise(enterprise);

      await sut.updateEnterprise(EnterpriseBuilder.entity!);

      var enterpriseWithCorrectValues = EnterpriseEntity(
        enterpriseName:
            enterprise.enterpriseName.toLowerCase().removeWhiteSpaces(),
        url: enterprise.url?.toLowerCase().removeWhiteSpaces(),
        concentradorUrl:
            enterprise.concentradorUrl?.toLowerCase().removeWhiteSpaces(),
        urlCCS: enterprise.urlCCS?.toLowerCase().removeWhiteSpaces(),
        canInsertCustomer: enterprise.canInsertCustomer,
        updateDevicesInformations:
            (enterprise.updateDevicesInformations ?? 0) + 1,
        updateEnterprise: (enterprise.updateEnterprise ?? 0) + 1,
        serviceChargePercentageOrValue:
            enterprise.serviceChargePercentageOrValue,
        enterpriseId: enterprise.enterpriseId,
        persistApp: false,
        useCovenant: enterprise.useCovenant,
        enterpriseConcentradorParametersEntity: null,
        zoomImage: enterprise.zoomImage,
        latestCompatibleVersion: enterprise.latestCompatibleVersion,
        minutesVerifyUpdateMenu: enterprise.minutesVerifyUpdateMenu,
        useReducedNameOnProduct: enterprise.useReducedNameOnProduct,
        verifyCommandBlocked: enterprise.verifyCommandBlocked,
        canInsertCommentManually: enterprise.canInsertCommentManually,
        blockUseAppIfIsOutdated: enterprise.blockUseAppIfIsOutdated,
        canInsertQuantityManually: enterprise.canInsertQuantityManually,
        requestTableNumber: enterprise.requestTableNumber,
      );

      verify(() =>
              updateEnterpriseParameters.update(enterpriseWithCorrectValues))
          .called(1);
    });
    test("Should update enterprise with correct values when pass null values",
        () async {
      final enterprise = EnterpriseBuilder.entity!;
      sut.goToAddOrEditEnterprise(enterprise);

      final newEntity = EnterpriseEntity(
        persistApp: false,
        enterpriseName: enterprise.enterpriseName,
        enterpriseId: enterprise.enterpriseId!,
        updateDevicesInformations: enterprise.updateDevicesInformations! + 1,
        updateEnterprise: enterprise.updateEnterprise! + 1,
        enterpriseConcentradorParametersEntity: null,
        url: null,
        concentradorUrl: null,
        urlCCS: null,
        verifyCommandBlocked: null,
        latestCompatibleVersion: null,
        serviceChargePercentageOrValue: null,
        zoomImage: null,
        useCovenant: null,
        minutesVerifyUpdateMenu: null,
        useReducedNameOnProduct: null,
        canInsertCommentManually: null,
        blockUseAppIfIsOutdated: null,
        canInsertQuantityManually: null,
        canInsertCustomer: null,
        requestTableNumber: null,
      );

      await sut.updateEnterprise(newEntity);

      verify(() => updateEnterpriseParameters.update(newEntity)).called(1);
    });

    test("Should return true on success", () async {
      final result = await sut.updateEnterprise(EnterpriseBuilder.entity!);

      expect(result, true);
    });

    test("Should return false on error", () async {
      updateEnterpriseParameters.mockUpdateError();

      final result = await sut.updateEnterprise(EnterpriseBuilder.entity!);

      expect(result, false);
    });
  });

  group("Delete enterprise", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      sut.goToAddOrEditEnterprise(EnterpriseBuilder.entity!);

      await sut.deleteEnterpriseData();
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      deleteEnterprise.mockDeleteError();

      sut.goToAddOrEditEnterprise(EnterpriseBuilder.entity!);

      await sut.deleteEnterpriseData();
    });
    test("Should emit error on selected enterprise is null", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );

      await sut.deleteEnterpriseData();
    });
    test("Should call deleteEnterprise with correct value", () async {
      sut.goToAddOrEditEnterprise(EnterpriseBuilder.entity!);

      await sut.deleteEnterpriseData();

      verify(
        () => deleteEnterprise.delete(sut.selectedEnterprise!.enterpriseName),
      ).called(1);
    });
    test("Should return true on success", () async {
      sut.goToAddOrEditEnterprise(EnterpriseBuilder.entity!);

      final result = await sut.deleteEnterpriseData();

      expect(result, true);
    });
    test("Should return false on error", () async {
      sut.goToAddOrEditEnterprise(EnterpriseBuilder.entity!);
      deleteEnterprise.mockDeleteError();

      final result = await sut.deleteEnterpriseData();

      expect(result, false);
    });
  });

  group("Get devices info", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.devicesStream, emitsInOrder([null, devices]));

      sut.goToAddOrEditEnterprise(EnterpriseBuilder.entity!);
      await sut.getDevicesInfo();
    });
    test("Should emit correct values on unexpected error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.unexpected]),
      );
      expectLater(sut.devicesStream, emits(null));

      loadDevicesInfo.mockLoadError(DomainError.unexpected);

      sut.goToAddOrEditEnterprise(EnterpriseBuilder.entity!);
      await sut.getDevicesInfo();
    });
    test("Should emit correct values on not found error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.notFound]),
      );
      expectLater(sut.devicesStream, emits(null));

      loadDevicesInfo.mockLoadError(DomainError.notFound);

      sut.goToAddOrEditEnterprise(EnterpriseBuilder.entity!);
      await sut.getDevicesInfo();
    });

    test("Should emit correct values on selected enterprise is null", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.devicesStream, emits(null));

      await sut.getDevicesInfo();
    });
    test("Should call loadDevicesInfo with correct parameter", () async {
      sut.goToAddOrEditEnterprise(EnterpriseBuilder.entity!);

      await sut.getDevicesInfo();

      verify(() =>
              loadDevicesInfo.load(EnterpriseBuilder.entity!.enterpriseName))
          .called(1);
    });
  });

  group("Go to device informations page", () {
    test("Should call navigate to with correct route", () {
      sut.goToDevicesInfoPage();

      verify(() => navigateTo.navigate(pageRoute: PageRoutes.webDevicesInfo))
          .called(1);
    });
  });
}
