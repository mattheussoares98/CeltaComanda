// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:clean_celta_mobile/ui/pages/products/products.dart';

import 'dart:async';
import 'package:mocktail/mocktail.dart';

class ProductsPresenterSpy extends Mock implements ProductsPresenter {
  final navigateToController = StreamController<String?>();
  final mainErrorController =
      StreamController<List<ProductsViewModel>>();
  final isLoadingController = StreamController<bool>();
  final expansibleGroupsController =
      StreamController<List<ProductsViewModel>>();

  ProductsPresenterSpy() {
    when(() => this.loadProducts()).thenAnswer((_) async => _);
    when(() => this.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
    when(() => this.productsStream)
        .thenAnswer((_) => expansibleGroupsController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
  }
  // void mockExpansibleGroupStreamError(DomainError error) {
  //   expansibleGroupsController.addError(
  //     UIError.unexpected.description,
  //     StackTrace.current,
  //   );
  // }

  void emitNavigateTo(String route) => navigateToController.add(route);
  void emitLoading([bool show = true]) => isLoadingController.add(show);

  void dispose() {
    navigateToController.close();
    mainErrorController.close();
    isLoadingController.close();
  }
}
