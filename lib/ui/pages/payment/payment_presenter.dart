import 'package:flutter/material.dart';

import '../../../domain/helpers/helpers.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class PaymentPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  double get totalPaidValue;
  double get lastRequestedPaymentAmount;

  Future<void> callPayment({
    required double longAmountValue,
    required int portionQuantity,
    required PaymentMode paymentMode,
    required HomePresenter homePresenter,
  });

  Future<void> liquidateCommand({
    required PrintedProductsPresenter printedProductsPresenter,
    required HomePresenter homePresenter,
  });

  void initPaymentResultHandler(
    HomePresenter homePresenter,
    PrintedProductsPresenter printedProductsPresenter,
  );

  void disposePaymentResultHandler();

  void goToCovenantPage();
}
