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

void main() {
  late GetxSplashPresenter sut;
  late NavigateToSpy navigateTo;
  late LocalEnterpriseDataSpy loadEnterpriseData;
  late GetPlataformSpy getPlataform;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  setUp(() {
    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();
    navigateTo = NavigateToSpy();
    loadEnterpriseData = LocalEnterpriseDataSpy();
    getPlataform = GetPlataformSpy();
    loadEnterpriseData.mockLoad(EnterpriseDataBuilder.enterpriseDataEntity!);
    sut = GetxSplashPresenter(
      navigateTo: navigateTo,
      loadEnterpriseData: loadEnterpriseData,
      getPlataform: getPlataform,
    );
  });

  group("Go to home page", () {
    test('Should go to home page on success to load data of API', () async {
      getPlataform.mockIsWeb(false);
      await sut.checkPageToGo(durationInSeconds: 0);

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
      getPlataform.mockIsWeb(false);
      loadEnterpriseData.mockLoad(null);

      await sut.checkPageToGo(durationInSeconds: 0);

      verify(
        () => navigateTo.navigate(
          pageRoute: PageRoutes.enterpriseValidation,
          clear: true,
        ),
      ).called(1);
    });
    test('Should go to enterprise validation if EnterpriseId is null',
        () async {
      getPlataform.mockIsWeb(false);
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
        ),
      );

      await sut.checkPageToGo(durationInSeconds: 0);

      verify(
        () => navigateTo.navigate(
          pageRoute: PageRoutes.enterpriseValidation,
          clear: true,
        ),
      ).called(1);
    });
    test('Should go to enterprise validation if url is null', () async {
      getPlataform.mockIsWeb(false);
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
        ),
      );

      await sut.checkPageToGo(durationInSeconds: 0);

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

      await sut.checkPageToGo();

      verify(() => navigateTo.navigate(
          pageRoute: PageRoutes.enterpriseValidation, clear: true)).called(1);
    });
  });

  group("Go to web login page", () {
    test("Should call getPlataform.isWeb", () async {
      await sut.checkPageToGo();

      verify(() => getPlataform.isWeb()).called(1);
    });
    test("Should go to webLoginPage if is web page", () async {
      await sut.checkPageToGo();

      verify(() =>
              navigateTo.navigate(pageRoute: PageRoutes.webLogin, clear: true))
          .called(1);
    });
  });
}
