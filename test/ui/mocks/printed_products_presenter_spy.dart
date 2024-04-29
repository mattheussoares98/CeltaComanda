// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import 'dart:async';
import 'package:mocktail/mocktail.dart';

import '../../domain/mocks/mocks.dart';

class PrintedProductsPresenterSpy extends Mock
    implements PrintedProductsPresenter {
  final isLoadingController = StreamController<bool>();
  final mainErrorController = StreamController<UIError?>();
  PrintedViewModel printedProductsMock = EntityFactory.makePrintedViewModel();

  PrintedProductsPresenterSpy() {
    mockIsValidPasswordAndCanCancel(true);
    mockGetPrintedProducts();
    mockClearPrintedProducts();

    when(() => this.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(() => this.printedProducts).thenAnswer((_) => printedProductsMock);
    when(() => this.removeProduct(
          password: any(named: "password"),
          personalizedCode: any(named: "personalizedCode"),
        )).thenAnswer((_) async => _);
  }

  When mockIsValidPassordCall() => when(() => this.isValidPasswordAndCanCancel(
        personalizedCode: any(named: "personalizedCode"),
        password: any(named: "password"),
      ));
  mockIsValidPasswordAndCanCancel(bool value) {
    this.mockIsValidPassordCall().thenAnswer((_) async => value);
  }

  When mockGetPrintedProductsCall() =>
      when(() => this.getPrintedProducts(any()));

  mockGetPrintedProducts() {
    this.mockGetPrintedProductsCall().thenAnswer((_) async => _);
  }

  When mockClearPrintedProductsCall() =>
      when(() => this.clearPrintedProducts());

  mockClearPrintedProducts() {
    this.mockClearPrintedProductsCall().thenAnswer((_) async => _);
  }

  void dispose() {
    isLoadingController.close();
    mainErrorController.close();
  }
}
