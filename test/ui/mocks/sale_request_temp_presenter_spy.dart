// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import 'dart:async';

import 'package:mocktail/mocktail.dart';


class SaleRequestTempPresenterSpy extends Mock
    implements SaleRequestTempPresenter {
  final isLoadingController = StreamController<bool>();
  final mainErrorController = StreamController<UIError?>();
  SaleRequestTempViewModel? saleRequestTempMock;

  SaleRequestTempPresenterSpy() {
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(() => this.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);

    when(() => this.saleRequestTemp).thenAnswer((_) => saleRequestTempMock);

    when(() => this.load(any())).thenAnswer((_) async => _);
    mockAddProductQuantityCall().thenAnswer((_) async => _);

    mockSubtractProductQuantityCall().thenAnswer((_) async => _);
    when(() => this.clear()).thenAnswer((_) async => _);
  }

  void mockLoadSaleRequestTempError() {
    when(() => this.load(any())).thenThrow(
      DomainError.unexpected,
    );
  }

  When mockSubtractProductQuantityCall() {
    return when(() => this.subtractProductQuantity(
          saleRequestProductTempId: any(named: "saleRequestProductTempId"),
          url: any(named: "url"),
        ));
  }

  void mockSubtractProductQuantityError() {
    mockSubtractProductQuantityCall().thenThrow(DomainError.unexpected);
  }

  When mockAddProductQuantityCall() {
    return when(() => this.addProductQuantity(
          saleRequestProductTempId: any(named: "saleRequestProductTempId"),
          url: any(named: "url"),
        ));
  }

  void mockAddProductQuantityError() {
    mockAddProductQuantityCall().thenThrow(DomainError.unexpected);
  }

  void emitLoading([bool show = true]) => isLoadingController.add(show);
  void addSaleRequestTempViewModel(SaleRequestTempViewModel? data) =>
      saleRequestTempMock = data;
}
