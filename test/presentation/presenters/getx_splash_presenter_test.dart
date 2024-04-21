import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/domain_error.dart';
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
  late LoadApiSaleRequestSpy loadApiSaleRequest;
  late ApiSaleRequestEntity apiSaleRequestEntity;
  late LocalEnterpriseDataSpy loadEnterpriseData;
  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  setUp(() {
    EnterpriseDataBuilder.enterpriseDataEntity = EntityFactory.makeEnterpriseData();
    navigateTo = NavigateToSpy();
    loadApiSaleRequest = LoadApiSaleRequestSpy();
    navigateTo.mockNavigate();
    apiSaleRequestEntity = EntityFactory.makeApiSaleRequestEntity();
    loadApiSaleRequest.mockLoadApiSaleRequest(apiSaleRequestEntity);
    loadEnterpriseData = LocalEnterpriseDataSpy();
    loadEnterpriseData.mockLoad(EnterpriseDataBuilder.enterpriseDataEntity!);
    sut = GetxSplashPresenter(
      navigateTo: navigateTo,
      loadApiSaleRequest: loadApiSaleRequest,
      loadEnterpriseData: loadEnterpriseData,
    );
  });

  test('Should call LoadApiSaleRequestEntity', () async {
    await sut.checkApiSaleRequest(durationInSeconds: 0);

    verify(() => loadApiSaleRequest.load(
          enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        )).called(1);
  });

  test('Should go to EnterpriseValidationPage if loadApiSaleRequest throws',
      () async {
    loadApiSaleRequest.mockError(DomainError.enterpriseOrUrlNotFound);

    await sut.checkApiSaleRequest(durationInSeconds: 0);

    verify(
      () => navigateTo.navigate(
        pageRoute: PageRoutes.enterpriseValidation,
        clear: true,
      ),
    ).called(1);
  });

  test('Should go to surveys page on success', () async {
    await sut.checkApiSaleRequest(durationInSeconds: 0);

    verify(
      () => navigateTo.navigate(
        pageRoute: PageRoutes.expansibleGroups,
        clear: true,
      ),
    ).called(1);
  });

  test('Should go to enterprise page if loadApiSaleRequest returns null', () async {
    loadApiSaleRequest.mockLoadApiSaleRequest(null);
    await sut.checkApiSaleRequest(durationInSeconds: 0);

    verify(
      () => navigateTo.navigate(
        pageRoute: PageRoutes.enterpriseValidation,
        clear: true,
      ),
    ).called(1);
  });
}
