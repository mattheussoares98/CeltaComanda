// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/domain_error.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import 'dart:async';
import 'package:mocktail/mocktail.dart';

import '../../domain/mocks/mocks.dart';

class PrintedProductsPresenterSpy extends Mock
    implements PrintedProductsPresenter {
  final mainErrorController = StreamController<UIError?>();
  final isLoadingController = StreamController<bool>();
  final alertMessageController = StreamController<String?>();
  PrintedViewModel printedProductsMock = EntityFactory.makePrintedViewModel();
  bool canCancelProductsController = false;
  double totalLiquidController = 0;

  PrintedProductsPresenterSpy() {
    when(() => this.totalLiquid).thenAnswer((_) => totalLiquidController);
    when(() => this.printedProducts).thenAnswer((_) => printedProductsMock);
    when(() => this.canCancelProducts)
        .thenAnswer((_) => canCancelProductsController);
    when(() => this.updateCanCancelProducts(any())).thenAnswer((any) => any);
    when(() => this.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(() => this.alertMessageStream)
        .thenAnswer((_) => alertMessageController.stream);

    mockLoadPrintedCall().thenAnswer((any) async => any);
    when(() => this.clear()).thenAnswer((any) => any);
    when(() => this.doOnClosePage()).thenAnswer((any) => any);
    when(() => this.validateUserAndPermissionToCancelProducts(
          personalizedCode: any(named: "personalizedCode"),
          password: any(named: "password"),
        )).thenAnswer((any) async => any);
  }

  void mockRemoveProduct() {
    when(() => this.removeProduct(
          saleRequestProductId: any(named: "saleRequestProductId"),
          menuPresenter: any(named: "menuPresenter"),
          cartPresenter: any(named: "cartPresenter"),
          expansibleGroupFromProductPresenter:
              any(named: "expansibleGroupFromProductPresenter"),
          printedProductsPresenter: any(named: "printedProductsPresenter"),
          homePresenter: any(named: "homePresenter"),
        )).thenAnswer((any) async => any);
  }

  When mockLoadPrintedCall() => when(() => this.loadPrinted(any()));

  void mockLoadPrintedError(DomainError error) {
    mockLoadPrintedCall().thenThrow(error);
  }
}
