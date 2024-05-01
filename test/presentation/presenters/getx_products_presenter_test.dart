import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/products/products.dart';
import 'package:faker/faker.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GetxProductsPresenter sut;
  late NavigateToSpy navigateTo;
  late LoadProductsSpy loadProducts;
  late List<ProductEntity> products;
  WidgetsFlutterBinding.ensureInitialized();
  late int expansibleGroupId;
  Get.testMode = true;

  setUp(() {
    expansibleGroupId = faker.randomGenerator.integer(3);
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

  test('Should call load products', () async {
    await sut.load(expansibleGroupId);

    verify(() => loadProducts.load(expansibleGroupId)).called(1);
  });

  test('Should throw DomainErrorUnexpected', () async {
    loadProducts.mockLoadProductsError();

    final future = sut.load(faker.randomGenerator.integer(3));

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should emit correct events on success', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.productsStream.listen(expectAsync1((products) => expect(products, [
          ProductsViewModel(
            SaleRetailPraticed: products[0].SaleRetailPraticed,
            PackingAbbreviation: products[0].PackingAbbreviation,
            Name: products[0].Name,
            EanCode: products[0].EanCode,
            PriceLookupCode: products[0].PriceLookupCode,
            ProductsId: products[0].ProductsId,
          ),
          ProductsViewModel(
            SaleRetailPraticed: products[1].SaleRetailPraticed,
            PackingAbbreviation: products[1].PackingAbbreviation,
            Name: products[1].Name,
            EanCode: products[1].EanCode,
            PriceLookupCode: products[1].PriceLookupCode,
            ProductsId: products[1].ProductsId,
          ),
        ])));

    await sut.load(faker.randomGenerator.integer(3));
  });

  test('Should go to surveys page on success', () async {
    final product = EntityFactory.makeProductViewModel();
    sut.goToProductDetailsPage(product);

    verify(
      () => navigateTo.navigate(
        pageRoute: PageRoutes.productDetails,
        arguments: product,
      ),
    ).called(1);
  });
}
