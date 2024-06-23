import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';

import '../../domain/mocks/mocks.dart';

import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';

void main() {
  late GetxSplashPresenter sut;
  late NavigateToSpy navigateTo;
  late LoadSaleRequestTempSpy loadSaleRequestTemp;
  late SaleRequestTempEntity apiSaleRequestEntity;
  late LocalEnterpriseDataSpy loadEnterpriseData;
  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  setUp(() {
    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();
    navigateTo = NavigateToSpy();
    loadSaleRequestTemp = LoadSaleRequestTempSpy();
    apiSaleRequestEntity = EntityFactory.makeApiSaleRequestEntity();
    loadSaleRequestTemp.mockLoadSaleRequestTemp(apiSaleRequestEntity);
    loadEnterpriseData = LocalEnterpriseDataSpy();
    loadEnterpriseData.mockLoad(EnterpriseDataBuilder.enterpriseDataEntity!);
    sut = GetxSplashPresenter(
      navigateTo: navigateTo,
      loadSaleRequestTemp: loadSaleRequestTemp,
      loadEnterpriseData: loadEnterpriseData,
    );
  });

  test('Should call LoadCommandsAvailableEntity', () async {
    await sut.checkApiSaleRequest(durationInSeconds: 0);

    verify(() => loadSaleRequestTemp.load(
          enterpriseId:
              EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          commandNumber: "001",
        )).called(1);
  });

  test('Should go to EnterpriseValidationPage if loadSaleRequestTemp throws',
      () async {
    loadSaleRequestTemp.mockError(DomainError.unexpected);

    await sut.checkApiSaleRequest(durationInSeconds: 0);

    verify(
      () => navigateTo.navigate(
        pageRoute: PageRoutes.enterpriseValidation,
        clear: true,
      ),
    ).called(1);
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
}
