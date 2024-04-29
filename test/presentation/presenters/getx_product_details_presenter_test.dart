import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';

import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';

import '../../domain/mocks/mocks.dart';

import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import '../../ui/mocks/sale_request_temp_presenter_spy.dart';

void main() {
  late GetxProductDetailsPresenter sut;
  late NavigateToSpy navigateTo;
  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeProductViewModel());
    registerFallbackValue(EntityFactory.makeSaleRequestTempProductsViewModel());
    registerFallbackValue(SaleRequestTempPresenterSpy());
  });

  setUp(() {
    navigateTo = NavigateToSpy();
    navigateTo.mockNavigate();
    sut = GetxProductDetailsPresenter(
      navigateTo: navigateTo,
    );
  });

  test('Should go to CartPage on CartIcon click', () async {
    sut.goToCartPage();

    verify(
      () => navigateTo.navigate(
        pageRoute: PageRoutes.saleRequestTemp,
      ),
    ).called(1);
  });
}
