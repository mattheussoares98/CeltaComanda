// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import 'dart:async';

import 'package:mocktail/mocktail.dart';

class SaleRequestTempPresenterSpy extends Mock
    implements SaleRequestTempPresenter {
  final mainErrorController = StreamController<UIError?>();
  final isLoadingController = StreamController<bool>();
  SaleRequestTempViewModel? saleRequestTempMock;
  List<CartProductsViewModel> cartProductsController = [];

  SaleRequestTempPresenterSpy() {
    when(() => this.saleRequestTemp).thenAnswer((_) => saleRequestTempMock);
    when(() => this.cartProducts).thenAnswer((_) => cartProductsController);
    when(() => this.getLocalCartProductsData()).thenAnswer((_) async => _);
    when(() => this.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);

    when(() => this.loadSaleRequest(any())).thenAnswer((_) async => _);
    mockAddProductQuantityCall().thenAnswer((_) async => _);

    mockSubtractProductQuantityCall().thenAnswer((_) async => _);
    when(() => this.clear()).thenAnswer((_) async => _);
  }

  void mockLoadSaleRequestTempError(DomainError error) {
    when(() => this.loadSaleRequest(any())).thenThrow(error);
  }

  When mockSubtractProductQuantityCall() {
    return when(() => this.subtractProductQuantity(
          saleRequestProductTempId: any(named: "saleRequestProductTempId"),
          url: any(named: "url"),
          productQuantity: any(named: "productQuantity"),
          commandNumber: any(named: "commandNumber"),
        ));
  }

  void mockSubtractProductQuantityError() {
    mockSubtractProductQuantityCall().thenThrow(DomainError.unexpected);
  }

  When mockAddProductQuantityCall() {
    return when(() => this.addProductQuantity(
          saleRequestProductTempId: any(named: "saleRequestProductTempId"),
          url: any(named: "url"),
          commandNumber: any(named: "commandNumber"),
        ));
  }

  void mockAddProductQuantityError() {
    mockAddProductQuantityCall().thenThrow(DomainError.unexpected);
  }

  void addSaleRequestTempViewModel(SaleRequestTempViewModel? data) =>
      saleRequestTempMock = data;
}
