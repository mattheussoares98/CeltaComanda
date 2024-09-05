import 'package:flutter/material.dart';

import '../../../domain/helpers/helpers.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class PaymentPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;

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

  Future<bool> getAlreadyPaid();

  Future<void> tryPayAgain(int commandNumber);
}
