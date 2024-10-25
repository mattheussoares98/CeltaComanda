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
  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  setUp(() {
    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();
    navigateTo = NavigateToSpy();
    loadEnterpriseData = LocalEnterpriseDataSpy();
    loadEnterpriseData.mockLoad(EnterpriseDataBuilder.enterpriseDataEntity!);
    sut = GetxSplashPresenter(
      navigateTo: navigateTo,
      loadEnterpriseData: loadEnterpriseData,
    );
  });

  test('Should go to home page on success to load data of API', () async {
    await sut.checkApiSaleRequest(durationInSeconds: 0);

    verify(
      () => navigateTo.navigate(
        pageRoute: PageRoutes.home,
        clear: true,
      ),
    ).called(1);
  });

  test('Should go to home page if EnterpriseId is null', () async {
    EnterpriseDataBuilder.enterpriseDataEntity = null;

    await sut.checkApiSaleRequest(durationInSeconds: 0);

    verify(
      () => navigateTo.navigate(
        pageRoute: PageRoutes.home,
        clear: true,
      ),
    ).called(1);
  });

  test('Should go to menu page if EnterpriseId is not null', () async {
    loadEnterpriseData.mockLoad(
      EnterpriseEntity(
        enterpriseName: "enterpriseName",
        enterpriseId: faker.randomGenerator.integer(100),
        concentradorUrl: faker.internet.httpUrl(),
        urlCCS: faker.internet.httpUrl(),
        url: faker.internet.httpUrl(),
        persistApp: faker.randomGenerator.boolean(),
        useCovenant: faker.randomGenerator.boolean(),
        enterpriseConcentradorParametersEntity:
            EntityFactory.makeEnterpriseConcentradorParametersEntity(),
        updateMenuCount: faker.randomGenerator.integer(100),
        updateEnterpriseCount: faker.randomGenerator.integer(100),
        serviceChargePercentageOrValue: faker.randomGenerator.decimal(),
        serviceChargeType: faker.randomGenerator.integer(2, min: 1),
      ),
    );

    await sut.checkApiSaleRequest(durationInSeconds: 0);

    verify(
      () => navigateTo.navigate(
        pageRoute: PageRoutes.home,
        clear: true,
      ),
    ).called(1);
  });
}
