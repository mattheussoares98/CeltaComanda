// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import 'dart:async';
import 'package:mocktail/mocktail.dart';

class PaymentPresenterSpy extends Mock implements PaymentPresenter {
  final mainErrorController = StreamController<UIError?>();
  final isLoadingController = StreamController<bool>();
  bool commandAlreadyPaidController = false;

  PaymentPresenterSpy() {
    when(() => this.commandAlreadyPaid)
        .thenAnswer((_) => commandAlreadyPaidController);

    when(() => this.getAndUpdateAlreadyPaidCommand())
        .thenAnswer((any) async => any);
    when(() => this.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
  }

  void mockDoPayment() => when(
        () => this.doPayment(
          longAmountValue: any(named: "longAmountValue"),
          portionQuantity: any(named: "portionQuantity"),
          paymentMode: any(named: "paymentMode"),
          homePresenter: any(named: "homePresenter"),
          printedProductsPresenter: any(named: "printedProductsPresenter"),
        ),
      ).thenAnswer((any) async => any);

  void mockGetTotalValue() => when(
        () => this.getTotalValue(
          homePresenter: any(named: "homePresenter"),
          cartPresenter: any(named: "cartPresenter"),
          printedProductsPresenter: any(named: "printedProductsPresenter"),
          menuPresenter: any(named: "menuPresenter"),
          expansibleGroupFromProductPresenter:
              any(named: "expansibleGroupFromProductPresenter"),
        ),
      ).thenAnswer((any) async => any);

  void mockTryPayAgain() => when(
        () => this.liquidateCommand(
          printedProductsPresenter: any(named: "printedProductsPresenter"),
          homePresenter: any(named: "homePresenter"),
        ),
      ).thenAnswer((any) async => any);
}
