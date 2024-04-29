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
          saleRequestProductId: any(named: "saleRequestProductId"),
        )).thenAnswer((_) async => _);
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
