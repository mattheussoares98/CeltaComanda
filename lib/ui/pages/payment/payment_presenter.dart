import 'package:flutter/material.dart';

import '../../../domain/helpers/helpers.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class PaymentPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  bool get commandAlreadyPaid;

  Future<void> doPayment({
    required double longAmountValue,
    required int portionQuantity,
    required PaymentMode paymentMode,
    required String commandNumber,
  });

  Future<void> getTotalValue({
    required HomePresenter homePresenter,
    required CartPresenter cartPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required MenuPresenter menuPresenter,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
  });

  Future<void> getAndUpdateAlreadyPaidCommand();

  Future<void> tryPayAgain({
    required PrintedProductsPresenter printedProductsPresenter,
    required HomePresenter homePresenter,
  });
}
