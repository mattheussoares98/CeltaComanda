// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import 'dart:async';
import 'package:mocktail/mocktail.dart';

class PrintedProductsPresenterSpy extends Mock
    implements PrintedProductsPresenter {
  final isLoadingController = StreamController<bool>();
  final mainErrorController = StreamController<UIError?>();

  PrintedProductsPresenterSpy() {
    when(() => this.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
  }

  void dispose() {
    isLoadingController.close();
    mainErrorController.close();
  }
}
