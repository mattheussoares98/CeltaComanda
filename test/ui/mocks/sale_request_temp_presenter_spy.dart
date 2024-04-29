// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import 'dart:async';

import 'package:mocktail/mocktail.dart';

class SaleRequestTempPresenterSpy extends Mock implements SaleRequestTempPresenter {
  final isLoadingController = StreamController<bool>();
  final cartController = StreamController<List<ProductsViewModel>>();

  SaleRequestTempPresenterSpy() {
    // when(() => this.cartProducts).thenAnswer((_) => cartController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);

    when(() => this.addProductInCart(any())).thenAnswer(
      (_) async => _,
    );
  }
  void mockExpansibleGroupStreamError(DomainError error) {
    cartController.addError(
      UIError.unexpected.description,
      StackTrace.current,
    );
  }

  void emitLoading([bool show = true]) => isLoadingController.add(show);
}
