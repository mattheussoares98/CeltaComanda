import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import 'package:get/get.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';

import '../../domain/mocks/mocks.dart';

void main() {
  late GetxSaleRequestTempPresenter sut;
  late ProductsViewModel product;
  late LoadSaleRequestTempSpy loadSaleRequestTemp;
  late SaleRequestTempProductsViewModel saleRequestTempProductsViewModel;

  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  setUp(() {
    loadSaleRequestTemp = LoadSaleRequestTempSpy();
    saleRequestTempProductsViewModel =
        EntityFactory.makeSaleRequestTempProductsViewModel();
    product = EntityFactory.makeProductViewModel();

    sut = GetxSaleRequestTempPresenter(
      loadSaleRequestTemp: loadSaleRequestTemp,
    );
  });

  test('Should add product in cart', () async {
    sut.addProductInCart(saleRequestTempProductsViewModel);

    expect(product, sut.saleRequestTemp?.Products[0]);
  });
}
