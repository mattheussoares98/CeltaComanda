// ignore_for_file: unnecessary_this

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

  PrintedProductsPresenterSpy() {
    when(() => this.printedProducts).thenAnswer((_) => printedProductsMock);
    when(() => this.canCancelProducts)
        .thenAnswer((_) => canCancelProductsController);
    when(() => this.updateCanCancelProducts(any())).thenAnswer((_) => _);
    when(() => this.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(() => this.alertMessageStream)
        .thenAnswer((_) => alertMessageController.stream);

    when(() => this.loadPrinted(any())).thenAnswer((_) async => _);
    when(() => this.clear()).thenAnswer((_) async => _);
    when(() => this.validateUserAndPermissionToCancelProducts(
          personalizedCode: any(named: "personalizedCode"),
          password: any(named: "password"),
        )).thenAnswer((_) async => _);
  }

  void mockRemoveProduct() {
    when(() => this.removeProduct(
          saleRequestProductId: any(named: "saleRequestProductId"),
          menuPresenter: any(named: "menuPresenter"),
          printedProductsPresenter: any(named: "printedProductsPresenter"),
          cartPresenter: any(named: "cartPresenter"),
          homePresenter: any(named: "homePresenter"),
        )).thenAnswer((_) async => _);
  }

  void mockLoadCommandData() {
    when(() => this.loadCommandData(
          printedProductsPresenter: any(named: "printedProductsPresenter"),
          cartPresenter: any(named: "cartPresenter"),
          menuPresenter: any(named: "menuPresenter"),
          homePresenter: any(named: "homePresenter"),
          clearPermissionToCancelProducts:
              any(named: "clearPermissionToCancelProducts"),
          isRemovingProduct: any(named: "isRemovingProduct"),
          writedCommandNumberForRedeVersion:
              any(named: "writedCommandNumberForRedeVersion"),
        )).thenAnswer((_) async => _);
  }
}
