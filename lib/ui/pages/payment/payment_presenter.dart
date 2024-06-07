import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';

abstract class PaymentPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<double?> get totalAmountValueStream;

  Future<void> payWithCredit({
    required double longAmountValue,
    required int portionQuantity,
  });
  Future<void> payWithCreditPortion({
    required double longAmountValue,
    required int portionQuantity,
  });
  Future<void> payWithDebit({
    required double longAmountValue,
    required int portionQuantity,
  });
  Future<void> payWithPix({
    required double longAmountValue,
    required int portionQuantity,
  });

  Future<void> getTotalValue(int commandNumber);
}
