import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:faker/faker.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../domain/mocks/mocks.dart';

import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GetxProductDetailsPresenter sut;
  late NavigateToSpy navigateTo;
  late AddProductSpy addProduct;
  late ProductsViewModel product;
  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  setUp(() {
    navigateTo = NavigateToSpy();
    addProduct = AddProductSpy();
    product = ProductsViewModel(
      image: faker.internet.httpUrl(),
      price: faker.randomGenerator.decimal().toString(),
      name: faker.food.random.string(10),
      plu: faker.randomGenerator.integer(5).toString(),
    );
    navigateTo.mockNavigate();
    sut = GetxProductDetailsPresenter(
      navigateTo: navigateTo,
      addProduct: addProduct,
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
    sut.addProductInCart(product);

    verify(() => addProduct.add(product)).called(1);
  });
}
