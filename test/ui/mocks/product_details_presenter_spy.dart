// ignore_for_file: unnecessary_this

// import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
// import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import 'dart:async';
import 'package:mocktail/mocktail.dart';

class ProductDetailsPresenterSpy extends Mock
    implements ProductDetailsPresenter {
  final navigateToController = StreamController<String?>();
  final mainErrorController = StreamController<List<ProductsViewModel>>();
  final isLoadingController = StreamController<bool>();
  final productsController = StreamController<List<ProductsViewModel>>();

  ProductDetailsPresenterSpy() {
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
  }
  // void mockExpansibleGroupStreamError(DomainError error) {
  //   productsController.addError(
  //     UIError.unexpected.description,
  //     StackTrace.current,
  //   );
  // }

  void emitLoading([bool show = true]) => isLoadingController.add(show);

  void dispose() {
    navigateToController.close();
    mainErrorController.close();
    isLoadingController.close();
  }
}
