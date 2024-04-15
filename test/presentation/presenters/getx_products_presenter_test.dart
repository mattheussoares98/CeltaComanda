import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/products/products.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../domain/mocks/mocks.dart';

import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GetxProductsPresenter sut;
  late NavigateToSpy navigateTo;
  late LoadProductsSpy loadProducts;
  late List<ProductEntity> products;
  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  setUp(() {
    loadProducts = LoadProductsSpy();
    products = EntityFactory.makeProducts();
    loadProducts.mockLoadProducts(products);
    navigateTo = NavigateToSpy();
    navigateTo.mockNavigate();
    sut = GetxProductsPresenter(
      navigateTo: navigateTo,
      loadProducts: loadProducts,
    );
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeAccount());
  });

  test('Should call load products', () async {
    await sut.load();

    verify(() => loadProducts.load()).called(1);
  });

  test('Should throw DomainErrorUnexpected', () async {
    loadProducts.mockLoadProductsError();

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should emit correct events on success', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.productsStream.listen(expectAsync1((products) => expect(products, [
          ProductsViewModel(
            image: products[0].image,
            price: products[0].price,
            name: products[0].name,
            plu: products[0].plu,
          ),
          ProductsViewModel(
            image: products[1].image,
            price: products[1].price,
            name: products[1].name,
            plu: products[1].plu,
          ),
        ])));

    await sut.load();
  });

  test('Should update SelectedProduct', () async {
    sut.updateSelectedProduct(
      ProductsViewModel(
        image: products[0].image,
        price: products[0].price.toString(),
        name: products[0].name,
        plu: products[0].plu,
      ),
    );

    expect(
      ProductsViewModel(
        image: products[0].image,
        price: products[0].price.toString(),
        name: products[0].name,
        plu: products[0].plu,
      ),
      sut.selectedProduct,
    );
  });

  test('Should go to surveys page on success', () async {
    sut.goToProductDetailsPage();

    verify(
      () => navigateTo.navigate(
        pageRoute: PageRoutes.productDetails,
        arguments: sut.selectedProduct,
      ),
    ).called(1);
  });
}
