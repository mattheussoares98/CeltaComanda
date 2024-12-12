// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import 'dart:async';

import 'package:mocktail/mocktail.dart';

class CartPresenterSpy extends Mock implements CartPresenter {
  final mainErrorController = StreamController<UIError?>();
  final isLoadingController = StreamController<bool>();
  SaleRequestTempViewModel? saleRequestTempMock;
  List<CartProductsViewModel> cartProductsController = [];

  CartPresenterSpy() {
    when(() => this.saleRequestTemp).thenAnswer((_) => saleRequestTempMock);
    when(() => this.cartProducts).thenAnswer((_) => cartProductsController);
    when(() => this.getLocalCartProductsData()).thenAnswer((any) async => any);
    when(() => this.insertServiceChargeProduct(any(), any()))
        .thenAnswer((any) async => any);
    when(() => this.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);

    when(() => this.getSaleRequestTemp(any())).thenAnswer((any) async => any);
    when(() => this.clear()).thenAnswer((any) async => any);
  }

  void mockLoadSaleRequestTempError(DomainError error) {
    when(() => this.getSaleRequestTemp(any())).thenThrow(error);
  }

  void addSaleRequestTempViewModel(SaleRequestTempViewModel? data) =>
      saleRequestTempMock = data;
}
