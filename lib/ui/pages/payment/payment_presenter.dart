import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class PaymentPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;

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

  Future<void> getTotalValue({
    required HomePresenter homePresenter,
    required CartPresenter cartPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required MenuPresenter menuPresenter,
  });
}
