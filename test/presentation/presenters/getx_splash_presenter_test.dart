import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../domain/mocks/mocks.dart';

import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GetxSplashPresenter sut;
  late NavigateToSpy navigateTo;
  late LoadApiSaleRequestSpy loadApiSaleRequest;
  late ApiSaleRequestEntity apiSaleRequestEntity;
  late LocalLoadLoginDataSpy loadLoginData;
  late LoginDataEntity loginDataEntity;
  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  setUp(() {
    navigateTo = NavigateToSpy();
    loadApiSaleRequest = LoadApiSaleRequestSpy();
    navigateTo.mockNavigate();
    apiSaleRequestEntity = EntityFactory.makeApiSaleRequestEntity();
    loadApiSaleRequest.mockLoadApiSaleRequest(apiSaleRequestEntity);
    loadLoginData = LocalLoadLoginDataSpy();
    loginDataEntity = EntityFactory.makeLoginData();
    sut = GetxSplashPresenter(
      navigateTo: navigateTo,
      loadApiSaleRequest: loadApiSaleRequest,
      loadLoginData: loadLoginData,
    );
  });

  test('Should call LoadApiSaleRequestEntity', () async {
    await sut.checkApiSaleRequest(durationInSeconds: 0);

    verify(() => loadApiSaleRequest.load(
          enterpriseId: loginDataEntity.enterpriseId!,
          url: loginDataEntity.url,
        )).called(1);
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

  test('Should go to login page if loadApiSaleRequest returns null', () async {
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
