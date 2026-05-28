// ignore_for_file: unnecessary_this

import 'dart:async';

import 'package:clean_celta_mobile/domain/helpers/domain_error.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
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
  double serviceChargeController = 0;

  PrintedProductsPresenterSpy() {
    when(() => this.getTotalLiquid(any()))
        .thenAnswer((_) => totalLiquidController);
    when(() => this.getServiceChargeValue(any()))
        .thenAnswer((_) => serviceChargeController);
    when(() => this.printed).thenAnswer((_) => printedProductsMock);
    when(() => this.canCancelProducts)
        .thenAnswer((_) => canCancelProductsController);
    when(() => this.updateCanCancelProducts(any())).thenAnswer((any) => any);
    when(() => this.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(() => this.alertMessageStream)
        .thenAnswer((_) => alertMessageController.stream);

    _mockLoadPrintedCall().thenAnswer((_) async => true);
    when(() => this.clear()).thenAnswer((any) => any);
    when(() => this.doOnClosePage()).thenAnswer((any) => any);
    when(() => this.validateUserAndPermissionToCancelProducts(
          personalizedCode: any(named: "personalizedCode"),
          password: any(named: "password"),
        )).thenAnswer((_) async => true);
  }

  void mockRemoveProduct() {
    when(() => this.removeProduct(
          saleRequestProductId: any(named: "saleRequestProductId"),
          menuPresenter: any(named: "menuPresenter"),
          cartPresenter: any(named: "cartPresenter"),
          expansibleGroupFromProductPresenter:
              any(named: "expansibleGroupFromProductPresenter"),
          printedProductsPresenter: any(named: "printedProductsPresenter"),
          commandNumber: any(named: "commandNumber"),
        )).thenAnswer((any) async => any);
  }

  When _mockLoadPrintedCall() => when(() => this.loadPrinted(
        any(),
        showIsLoading: any<bool>(named: "showIsLoading"),
      ));

  void mockLoadPrintedError(DomainError error) {
    _mockLoadPrintedCall().thenThrow(error);
  }

  void mockGetTotalLiquid(double value) {
    when(() => this.getTotalLiquid(any())).thenAnswer((_) => value);
  }

  void mockGetServiceChargeValue(double value) {
    when(() => this.getServiceChargeValue(any())).thenAnswer((_) => value);
  }
}
