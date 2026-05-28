import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/helpers/app_platform.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';
import '../../ui/mocks/mocks.dart';

void main() {
  late GetxSplashPresenter sut;
  late HomePresenterSpy homePresenter;

  late NavigateToSpy navigateTo;
  late LocalEnterpriseDataSpy loadEnterpriseData;
  late ObtainPlataformSpy obtainPlatform;
  late LocalCommandDataSpy localCommandData;
  late PdvRegistrationSpy pdvRegistration;
  late LoadDeviceDataSpy loadDeviceData;

  late CommandEntity commandEntity;
  late PdvEntity registeredPdv;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  void initUsecases() {
    navigateTo = NavigateToSpy();
    loadEnterpriseData = LocalEnterpriseDataSpy();
    obtainPlatform = ObtainPlataformSpy();
    localCommandData = LocalCommandDataSpy();
    pdvRegistration = PdvRegistrationSpy();
    loadDeviceData = LoadDeviceDataSpy();
  }

  void initPresenters() {
    homePresenter = HomePresenterSpy();

    sut = GetxSplashPresenter(
      navigateTo: navigateTo,
      loadEnterpriseData: loadEnterpriseData,
      obtainPlatform: obtainPlatform,
      localCommandData: localCommandData,
      pdvRegistration: pdvRegistration,
      loadDeviceData: loadDeviceData,
    );
  }

  void initEntitys() {
    EnterpriseBuilder.entity = EntityFactory.makeEnterpriseData();
    commandEntity = EntityFactory.makeCommandEntity();
    registeredPdv = EntityFactory.makePdvEntity();
  }

  void initMockSuccess() {
    loadEnterpriseData.mockLoad(EnterpriseBuilder.entity!);
    localCommandData.mockLoad(commandEntity);
    pdvRegistration.mockGetById(registeredPdv);
    obtainPlatform.mockIsWeb(false);
    loadDeviceData.mockGetImeiOrWindowsId(commandEntity.pdv!.MacAddress!);
  }

  setUp(() {
    initUsecases();
    initPresenters();
    initEntitys();
    initMockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeCommandEntity());
    registerFallbackValue(EntityFactory.makePdvEntity());
  });

  group("Is web", () {
    test("Should call getPlataform.isWeb", () async {
      await sut.checkPageToGo(homePresenter: homePresenter);

      verify(() => obtainPlatform.isWeb()).called(1);
    });
    test("Should go to webLoginPage if is web page", () async {
      obtainPlatform.mockIsWeb(true);
      await sut.checkPageToGo(homePresenter: homePresenter);

      verify(() =>
              navigateTo.navigate(pageRoute: PageRoutes.webLogin, clear: true))
          .called(1);
    });
  });

  group("Enterprise id or url is null", () {
    test('Should go to enterprise validation if EnterpriseId is null',
        () async {
      loadEnterpriseData.mockLoad(
        EnterpriseEntity.empty('enterpriseName'),
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
      loadEnterpriseData.mockLoad(
        EnterpriseEntity.empty('enterpriseName'),
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
  });

  group("Is generating version to rede or getnet", () {
    test(
        'Should call get pdv by id if local pdv is not null and is generating version to rede',
        () async {
      homePresenter.appPlatform = AppPlatform.rede;

      await sut.checkPageToGo(
        homePresenter: homePresenter,
        durationInSeconds: 0,
      );

      verify(() => pdvRegistration.getById(commandEntity.pdv!.PdvId!))
          .called(1);
    });

    test('Should call get pdv by id if local pdv is not null', () async {
      homePresenter.appPlatform = AppPlatform.getnet;

      await sut.checkPageToGo(
        homePresenter: homePresenter,
        durationInSeconds: 0,
      );

      verify(() => pdvRegistration.getById(commandEntity.pdv!.PdvId!))
          .called(1);
    });

    test("Should go to enterprise page dont have a pdv in local command data",
        () async {
      homePresenter.appPlatform = AppPlatform.getnet;

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
    test("Should go to home page if get pdv by id return null", () async {
      homePresenter.appPlatform = AppPlatform.getnet;
      pdvRegistration.mockGetById(null);

      await sut.checkPageToGo(
        homePresenter: homePresenter,
      );

      verify(() => navigateTo.navigate(pageRoute: PageRoutes.home, clear: true))
          .called(1);
    });
    test("Should call load imei or windows id", () async {
      homePresenter.appPlatform = AppPlatform.getnet;
      pdvRegistration.mockGetById(null);

      await sut.checkPageToGo(homePresenter: homePresenter);

      verify(() => loadDeviceData.getImeiOrWindowsId()).called(1);
    });
    test(
        "Should go to enterprise page if device id and remote id registered are differently",
        () async {
      homePresenter.appPlatform = AppPlatform.getnet;

      await sut.checkPageToGo(homePresenter: homePresenter);

      verify(() => navigateTo.navigate(
          pageRoute: PageRoutes.enterpriseValidation, clear: true)).called(1);
    });
    test(
        "Should call correct usecases if device id and remote id registered is equal",
        () async {
      homePresenter.appPlatform = AppPlatform.getnet;
      loadDeviceData.mockGetImeiOrWindowsId(registeredPdv.MacAddress!);
      final applicationVersion = faker.guid.guid();
      loadDeviceData.mockGetApplicationVersion(applicationVersion);

      await sut.checkPageToGo(homePresenter: homePresenter);

      verify(() => loadDeviceData.getApplicationVersion()).called(1);
      verify(() => pdvRegistration.updatePdvRegister(
            entity: registeredPdv,
            versionNumber: applicationVersion,
          )).called(1);
      verify(() => navigateTo.navigate(pageRoute: PageRoutes.home, clear: true))
          .called(1);
    });
    test("Should go to home page if update pdv register trhows", () async {
      //já validou que o mac é igual o id do dispositivo, não tem problema se não atualizar. Depois atualiza
      homePresenter.appPlatform = AppPlatform.getnet;
      loadDeviceData.mockGetImeiOrWindowsId(registeredPdv.MacAddress!);
      final applicationVersion = faker.guid.guid();
      loadDeviceData.mockGetApplicationVersion(applicationVersion);
      pdvRegistration.mockUpdatePdvRegisterError();

      await sut.checkPageToGo(
        homePresenter: homePresenter,
      );

      verify(() => navigateTo.navigate(pageRoute: PageRoutes.home, clear: true))
          .called(1);
    });
  });

  group("Throws navigations", () {
    test('Should go to enterprise validation enterprise is null', () async {
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

    test("Should go to enterprise page if get enterprise data throws",
        () async {
      loadEnterpriseData.mockLoadError();

      await sut.checkPageToGo(
        homePresenter: homePresenter,
      );

      verify(() => navigateTo.navigate(
          pageRoute: PageRoutes.enterpriseValidation, clear: true)).called(1);
    });
  });

  group('Web sale details page', () {
    test(
        "Should go to validation page if is generating respective version and has local enterprise",
        () async {
      homePresenter.appPlatform = AppPlatform.webSaleRequestDetails;

      await sut.checkPageToGo(homePresenter: homePresenter);

      verify(() => navigateTo.navigate(
            pageRoute: PageRoutes.webSaleRequestDetails,
            clear: true,
          )).called(1);
    });
  });
}
