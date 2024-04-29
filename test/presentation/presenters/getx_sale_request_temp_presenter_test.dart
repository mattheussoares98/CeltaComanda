import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import 'package:get/get.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';

import '../../domain/mocks/mocks.dart';

void main() {
  late GetxCartPresenter sut;
  late ProductsViewModel product;
  late LoadSaleRequestTempSpy loadSaleRequestTemp;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  setUp(() {
    loadSaleRequestTemp = LoadSaleRequestTempSpy();
    product = EntityFactory.makeProductViewModel();
    
    sut = GetxCartPresenter(
      loadSaleRequestTemp: loadSaleRequestTemp,
    );
  });

  test('Should add product in cart', () async {
    sut.addProductInCart(product);

    expect(product, sut.saleRequestProducts[0]);
  });
}
