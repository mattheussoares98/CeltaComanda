import '../../helpers/helpers.dart';

import 'package:flutter/material.dart';

abstract class PrintedProductsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;

  Future<bool> userCanCancel({required int personalizedCode, required String password});
}
