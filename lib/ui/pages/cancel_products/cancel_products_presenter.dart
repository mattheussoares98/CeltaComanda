import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';

abstract class CancelProductsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;

  Future<void> cancelProduct(String productId);
}
