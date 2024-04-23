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
  late LoadCommandsAvailableSpy loadCommandsAvailable;
  late SaleRequestEntity apiSaleRequestEntity;
  late LocalEnterpriseDataSpy loadEnterpriseData;
  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  setUp(() {
    EnterpriseDataBuilder.enterpriseDataEntity = EntityFactory.makeEnterpriseData();
    navigateTo = NavigateToSpy();
    loadCommandsAvailable = LoadCommandsAvailableSpy();
    navigateTo.mockNavigate();
    apiSaleRequestEntity = EntityFactory.makeApiSaleRequestEntity();
    loadCommandsAvailable.mockLoadCommandsAvailable(apiSaleRequestEntity);
    loadEnterpriseData = LocalEnterpriseDataSpy();
    loadEnterpriseData.mockLoad(EnterpriseDataBuilder.enterpriseDataEntity!);
    sut = GetxSplashPresenter(
      navigateTo: navigateTo,
      loadCommandsAvailable: loadCommandsAvailable,
      loadEnterpriseData: loadEnterpriseData,
    );
  });

  test('Should call LoadCommandsAvailableEntity', () async {
    await sut.checkApiSaleRequest(durationInSeconds: 0);

    verify(() => loadCommandsAvailable.load(
          enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          commandNumber: "001",
        )).called(1);
  });

  test('Should go to EnterpriseValidationPage if loadCommandsAvailable throws',
      () async {
    loadCommandsAvailable.mockError(DomainError.enterpriseOrUrlNotFound);

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

  test('Should go to enterprise page if loadCommandsAvailable returns null', () async {
    loadCommandsAvailable.mockLoadCommandsAvailable(null);
    await sut.checkApiSaleRequest(durationInSeconds: 0);

    verify(
      () => navigateTo.navigate(
        pageRoute: PageRoutes.enterpriseValidation,
        clear: true,
      ),
    ).called(1);
  });
}
