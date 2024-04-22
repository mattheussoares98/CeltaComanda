import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import 'package:get/get.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';

import '../../domain/mocks/mocks.dart';

void main() {
  late GetxCartPresenter sut;
  late ProductsViewModel product;
  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  setUp(() {
    product = EntityFactory.makeProductViewModel();
    sut = GetxCartPresenter();
  });

  test('Should add product in cart', () async {
    sut.addProductInCart(product);

    expect(product, sut.cartProducts[0]);
  });
}
