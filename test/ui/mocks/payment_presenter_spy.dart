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
    when(() => this.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
  }

  void mockDoPayment() => when(
        () => this.callPayment(
          longAmountValue: any(named: "longAmountValue"),
          portionQuantity: any(named: "portionQuantity"),
          paymentMode: any(named: "paymentMode"),
          homePresenter: any(named: "homePresenter"),
        ),
      ).thenAnswer((any) async => any);

  void mockTryPayAgain() => when(
        () => this.liquidateCommand(
          printedProductsPresenter: any(named: "printedProductsPresenter"),
          homePresenter: any(named: "homePresenter"),
        ),
      ).thenAnswer((any) async => any);

  void mockGetTotalPendingValue(double value) => when(
        () => this.getTotalPendingValue(any()),
      ).thenAnswer((any) => value);
}
