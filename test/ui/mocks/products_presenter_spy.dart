// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import 'dart:async';
import 'package:mocktail/mocktail.dart';

class ProductsPresenterSpy extends Mock implements ProductsPresenter {
  final navigateToController = StreamController<String?>();
  final mainErrorController = StreamController<List<ProductsViewModel>>();
  final isLoadingController = StreamController<bool>();
  final productsController = StreamController<List<ProductsViewModel>>();

  ProductsPresenterSpy() {
    when(() => this.loadProducts()).thenAnswer((_) async => _);
    when(() => this.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
    when(() => this.productsStream)
        .thenAnswer((_) => productsController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
  }
  void mockExpansibleGroupStreamError(DomainError error) {
    productsController.addError(
      UIError.unexpected.description,
      StackTrace.current,
    );
  }

  void emitNavigateTo(String route) => navigateToController.add(route);
  void emitLoading([bool show = true]) => isLoadingController.add(show);

  void dispose() {
    navigateToController.close();
    mainErrorController.close();
    isLoadingController.close();
  }
}
