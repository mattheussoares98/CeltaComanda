import 'package:flutter/material.dart';

import '../pages.dart';

abstract class SaleRequestTempPresenter implements ChangeNotifier {
  SaleRequestTempViewModel? get saleRequestTemp;
  Stream<bool> get isLoadingStream;

  Future<void> load(String commandNumber);
  void clear();
}
