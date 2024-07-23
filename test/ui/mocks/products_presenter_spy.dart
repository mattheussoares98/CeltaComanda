// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import 'dart:async';

import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

class ProductsPresenterSpy extends Mock implements ProductsPresenter {
  final mainErrorController = StreamController<UIError>();
  final isLoadingController = StreamController<bool>();
  final productsController = StreamController<List<ProductsViewModel>>();

  ProductsPresenterSpy() {
    when(() => this.load(any())).thenAnswer((_) async => _);
    when(() => this.updateSaleRequest(
          productsViewModel: any(named: "productsViewModel"),
          homePresenter: any(named: "homePresenter"),
          cartPresenter: any(named: "cartPresenter"),
          products: any(named: "products"),
        )).thenAnswer((_) async => _);
    when(() => this.productsStream)
        .thenAnswer((_) => productsController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(() => this.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
  }

  void mockProductStreamError(DomainError error) {
    productsController.addError(
      UIError.unexpected.description,
      StackTrace.current,
    );
  }

  void mockGoToComboxPage(ProductsViewModel product) {
    when(() => this.goToComboxPage(any())).thenAnswer((_) => Get.offNamed(
          PageRoutes.productComposition,
          arguments: product,
        ));
  }

  void emitLoading([bool show = true]) => isLoadingController.add(show);

  @override
  void dispose() {
    mainErrorController.close();
    isLoadingController.close();
  }
}
