import '../../helpers/helpers.dart';

import 'package:flutter/material.dart';

abstract class PrintedProductsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<UIError?> get enterpriseErrorStream;
  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingStream;

  Future<void> loadRemoteData();
}
