import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';

abstract class PaymentPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;

  Future<void> payWithCredit({
    required int longAmountValue,
    required int portionQuantity,
  });
  Future<void> payWithCreditPortion({
    required int longAmountValue,
    required int portionQuantity,
  });
  Future<void> payWithDebit({
    required int longAmountValue,
    required int portionQuantity,
  });
  Future<void> payWithPix({
    required int longAmountValue,
    required int portionQuantity,
  });
}
