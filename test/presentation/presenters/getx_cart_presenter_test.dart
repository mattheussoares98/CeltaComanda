import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import 'package:get/get.dart';
import 'package:faker/faker.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';

void main() {
  late GetxCartPresenter sut;
  late ProductsViewModel product;
  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  setUp(() {
    product = ProductsViewModel(
      image: faker.internet.httpUrl(),
      price: faker.randomGenerator.decimal().toString(),
      name: faker.food.random.string(10),
      plu: faker.randomGenerator.integer(5).toString(),
    );
    sut = GetxCartPresenter();
  });

  test('Should call addProduct with correct product', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    // sut.cartProducts.listen(expectAsync1((products) => expect(products, [
    //       ProductsViewModel(
    //         image: products[0].image,
    //         price: products[0].price,
    //         name: products[0].name,
    //         plu: products[0].plu,
    //       ),
    //     ])));

    sut.addProductInCart(product);
  });
}
