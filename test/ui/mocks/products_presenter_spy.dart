// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:get/get.dart';

import 'dart:async';
import 'package:mocktail/mocktail.dart';

import '../../domain/mocks/mocks.dart';

class ProductsPresenterSpy extends Mock implements ProductsPresenter {
  final mainErrorController = StreamController<List<ProductsViewModel>>();
  final isLoadingController = StreamController<bool>();
  final productsController = StreamController<List<ProductsViewModel>>();
  final selectedProductMock = EntityFactory.makeProductViewModel();

  ProductsPresenterSpy() {
    when(() => this.load(any())).thenAnswer((_) async => [selectedProductMock]);
    when(() => this.productsStream)
        .thenAnswer((_) => productsController.stream);
    when(() => this.selectedProduct).thenAnswer((_) => selectedProductMock);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(() => this.goToProductDetailsPage()).thenAnswer((_) => Get.offNamed(
          PageRoutes.productDetails,
          arguments: selectedProductMock,
        ));
    when(() => this.goToCartPage()).thenAnswer((_) => Get.offNamed(
          PageRoutes.cart,
        ));
  }
  void mockProductStreamError(DomainError error) {
    productsController.addError(
      UIError.unexpected.description,
      StackTrace.current,
    );
  }

  mockUpdateSelectedProduct(ProductsViewModel product) {
    when(() => this.updateSelectedProduct(any()))
        .thenAnswer((_) async => product);
  }

  void emitLoading([bool show = true]) => isLoadingController.add(show);

  void dispose() {
    mainErrorController.close();
    isLoadingController.close();
  }
}
