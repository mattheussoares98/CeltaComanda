import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:faker/faker.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';

import '../../ui/mocks/mocks.dart';

void main() {
  late GetxSplashPresenter sut;
  late HomePresenterSpy homePresenter;

  late NavigateToSpy navigateTo;
  late LocalEnterpriseDataSpy loadEnterpriseData;
  late ObtainPlataformSpy obtainPlatform;
  late LocalCommandDataSpy localCommandData;
  late PdvRegistrationSpy pdvRegistration;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    navigateTo = NavigateToSpy();
    loadEnterpriseData = LocalEnterpriseDataSpy();
    obtainPlatform = ObtainPlataformSpy();
    localCommandData = LocalCommandDataSpy();
    pdvRegistration = PdvRegistrationSpy();
  }

  void initPresenters() {
    homePresenter = HomePresenterSpy();

    sut = GetxSplashPresenter(
      navigateTo: navigateTo,
      loadEnterpriseData: loadEnterpriseData,
      obtainPlatform: obtainPlatform,
      localCommandData: localCommandData,
      pdvRegistration: pdvRegistration,
    );
  }

  void initEntitys() {
    EnterpriseBuilder.entity = EntityFactory.makeEnterpriseData();
  }

  void initMockSuccess() {
    loadEnterpriseData.mockLoad(EnterpriseBuilder.entity!);
    localCommandData.mockLoad(EntityFactory.makeCommandEntity());
  }

  setUp(() {
    initUsecases();
    initPresenters();
    initEntitys();
    initMockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeCommandEntity());
  });

  group("Go to home page", () {
    test('Should go to home page on success to load data of API', () async {
      obtainPlatform.mockIsWeb(false);
      await sut.checkPageToGo(
        homePresenter: homePresenter,
        durationInSeconds: 0,
      );

      verify(
        () => navigateTo.navigate(
          pageRoute: PageRoutes.home,
          clear: true,
        ),
      ).called(1);
    });
  });

  group("Go to enterprise validation page", () {
    test('Should go to enterprise validation enterprise is null', () async {
      obtainPlatform.mockIsWeb(false);
      loadEnterpriseData.mockLoad(null);

      await sut.checkPageToGo(
        homePresenter: homePresenter,
        durationInSeconds: 0,
      );

      verify(
        () => navigateTo.navigate(
          pageRoute: PageRoutes.enterpriseValidation,
          clear: true,
        ),
      ).called(1);
    });
    test('Should go to enterprise validation if EnterpriseId is null',
        () async {
      obtainPlatform.mockIsWeb(false);
      loadEnterpriseData.mockLoad(
        EnterpriseEntity(
          enterpriseName: "enterpriseName",
          enterpriseId: null,
          concentradorUrl: faker.internet.httpUrl(),
          urlCCS: faker.internet.httpUrl(),
          url: faker.internet.httpUrl(),
          persistApp: faker.randomGenerator.boolean(),
          useCovenant: faker.randomGenerator.boolean(),
          enterpriseConcentradorParametersEntity:
              EntityFactory.makeEnterpriseConcentradorParametersEntity(),
          updateMenu: faker.randomGenerator.integer(100),
          updateEnterprise: faker.randomGenerator.integer(100),
          updateConcentratorEnterpriseData: faker.randomGenerator.integer(100),
          updateDevicesInformations: faker.randomGenerator.integer(100),
          serviceChargePercentageOrValue: faker.randomGenerator.decimal(),
          serviceChargeType: faker.randomGenerator.integer(2, min: 1),
          zoomImage: faker.randomGenerator.boolean(),
          pendingDevicesToUpdate: [
            faker.randomGenerator.string(10),
            faker.randomGenerator.string(10),
          ],
          updatePendingDevices: faker.randomGenerator.integer(100),
          waitDaysToPreloadImages: faker.randomGenerator.integer(100),
          secondsPreloadingImages: faker.randomGenerator.integer(100),
        ),
      );

      await sut.checkPageToGo(
        homePresenter: homePresenter,
        durationInSeconds: 0,
      );

      verify(
        () => navigateTo.navigate(
          pageRoute: PageRoutes.enterpriseValidation,
          clear: true,
        ),
      ).called(1);
    });
    test('Should go to enterprise validation if url is null', () async {
      obtainPlatform.mockIsWeb(false);
      loadEnterpriseData.mockLoad(
        EnterpriseEntity(
          enterpriseName: "enterpriseName",
          enterpriseId: faker.randomGenerator.integer(100),
          concentradorUrl: faker.internet.httpUrl(),
          urlCCS: faker.internet.httpUrl(),
          url: null,
          persistApp: faker.randomGenerator.boolean(),
          useCovenant: faker.randomGenerator.boolean(),
          enterpriseConcentradorParametersEntity:
              EntityFactory.makeEnterpriseConcentradorParametersEntity(),
          updateMenu: faker.randomGenerator.integer(100),
          updateEnterprise: faker.randomGenerator.integer(100),
          updateConcentratorEnterpriseData: faker.randomGenerator.integer(100),
          updateDevicesInformations: faker.randomGenerator.integer(100),
          serviceChargePercentageOrValue: faker.randomGenerator.decimal(),
          serviceChargeType: faker.randomGenerator.integer(2, min: 1),
          zoomImage: faker.randomGenerator.boolean(),
          pendingDevicesToUpdate: [
            faker.randomGenerator.string(10),
            faker.randomGenerator.string(10),
          ],
          updatePendingDevices: faker.randomGenerator.integer(100),
          waitDaysToPreloadImages: faker.randomGenerator.integer(100),
          secondsPreloadingImages: faker.randomGenerator.integer(100),
        ),
      );

      await sut.checkPageToGo(
        homePresenter: homePresenter,
        durationInSeconds: 0,
      );

      verify(
        () => navigateTo.navigate(
          pageRoute: PageRoutes.enterpriseValidation,
          clear: true,
        ),
      ).called(1);
    });

    test("Should go to enterprise page if get enterprise data throws",
        () async {
      loadEnterpriseData.mockLoadError();

      await sut.checkPageToGo(
        homePresenter: homePresenter,
      );

      verify(() => navigateTo.navigate(
          pageRoute: PageRoutes.enterpriseValidation, clear: true)).called(1);
    });
    test(
        "Should go to enterprise page if is generating version to getnet and dont have a pdv in local command data",
        () async {
      homePresenter.isGeneratingVersionToGetNetMock = true;
      obtainPlatform.mockIsWeb(false);

      localCommandData.mockLoad(
        CommandEntity(
          commandNumber: faker.randomGenerator.integer(100).toString(),
          isFixedCommandNumber: faker.randomGenerator.boolean(),
          pdv: null,
        ),
      );

      await sut.checkPageToGo(
        homePresenter: homePresenter,
      );

      verify(() => navigateTo.navigate(
          pageRoute: PageRoutes.enterpriseValidation, clear: true)).called(1);
    });
    test(
        "Should go to enterprise page if is generating version to rede and dont have a pdv in local command data",
        () async {
      homePresenter.isGeneratingVersionToGetNetMock = true;
      obtainPlatform.mockIsWeb(false);

      localCommandData.mockLoad(
        CommandEntity(
          commandNumber: faker.randomGenerator.integer(100).toString(),
          isFixedCommandNumber: faker.randomGenerator.boolean(),
          pdv: null,
        ),
      );

      await sut.checkPageToGo(
        homePresenter: homePresenter,
      );

      verify(() => navigateTo.navigate(
          pageRoute: PageRoutes.enterpriseValidation, clear: true)).called(1);
    });
  });

  group("Go to web login page", () {
    test("Should call getPlataform.isWeb", () async {
      await sut.checkPageToGo(
        homePresenter: homePresenter,
      );

      verify(() => obtainPlatform.isWeb()).called(1);
    });
    test("Should go to webLoginPage if is web page", () async {
      await sut.checkPageToGo(
        homePresenter: homePresenter,
      );

      verify(() =>
              navigateTo.navigate(pageRoute: PageRoutes.webLogin, clear: true))
          .called(1);
    });
  });
}
