// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import 'dart:async';
import 'package:mocktail/mocktail.dart';

import '../../domain/mocks/mocks.dart';

class PrintedProductsPresenterSpy extends Mock
    implements PrintedProductsPresenter {
  final mainErrorController = StreamController<UIError?>();
  PrintedViewModel printedProductsMock = EntityFactory.makePrintedViewModel();
  bool canCancelProductsController = false;

  PrintedProductsPresenterSpy() {
    mockGetPrintedProducts();
    mockClearPrintedProducts();

    when(() => this.printedProducts).thenAnswer((_) => printedProductsMock);
    when(() => this.canCancelProducts)
        .thenAnswer((_) => canCancelProductsController);
    when(() => this.updateCanCancelProducts(any())).thenAnswer((_) => _);
  }

  void mockRemoveProduct() {
    when(() => this.removeProduct(
          saleRequestProductId: any(named: "saleRequestProductId"),
          expansibleGroupsPresenter: any(named: "expansibleGroupsPresenter"),
          printedProductsPresenter: any(named: "printedProductsPresenter"),
          saleRequestTempPresenter: any(named: "saleRequestTempPresenter"),
          homePresenter: any(named: "homePresenter"),
        )).thenAnswer((_) async => _);
  }

  When mockGetPrintedProductsCall() => when(() => this.loadPrinted(any()));

  mockGetPrintedProducts() {
    this.mockGetPrintedProductsCall().thenAnswer((_) async => _);
  }

  When mockClearPrintedProductsCall() => when(() => this.clear());

  mockClearPrintedProducts() {
    this.mockClearPrintedProductsCall().thenAnswer((_) async => _);
  }

  @override
  void dispose() {
    mainErrorController.close();
  }
}
