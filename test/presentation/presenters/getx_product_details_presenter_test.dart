import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';

import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import '../../domain/mocks/mocks.dart';

import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import '../../ui/mocks/cart_presenter_spy.dart';

void main() {
  late GetxProductDetailsPresenter sut;
  late CartPresenterSpy cartPresenter;
  late NavigateToSpy navigateTo;
  // late AddProductSpy addProduct;
  late ProductsViewModel product;
  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeProductViewModel());
    registerFallbackValue(CartPresenterSpy());
  });

  setUp(() {
    navigateTo = NavigateToSpy();
    cartPresenter = CartPresenterSpy();
    // addProduct = AddProductSpy();
    product = EntityFactory.makeProductViewModel();
    navigateTo.mockNavigate();
    sut = GetxProductDetailsPresenter(
      navigateTo: navigateTo,
    );
  });

  test('Should go to CartPage on CartIcon click', () async {
    sut.goToCartPage();

    verify(
      () => navigateTo.navigate(
        pageRoute: PageRoutes.cart,
      ),
    ).called(1);
  });

  test('Should call addProduct with correct product', () async {
    sut.addProductInCart(cartPresenter: cartPresenter, product: product);

    verify(() => cartPresenter.addProductInCart(product)).called(1);
  });
}
