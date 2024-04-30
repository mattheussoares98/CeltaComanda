import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

abstract class SaleRequestTempPresenter implements ChangeNotifier {
  SaleRequestTempViewModel? get saleRequestTemp;
  Stream<bool> get isLoadingStream;
  Stream<UIError?> get mainErrorStream;

  Future<void> load(String commandNumber);
  Future<void> addProductQuantity({
    required String url,
    required int saleRequestProductTempId,
  });
  Future<void> subtractProductQuantity({
    required String url,
    required int saleRequestProductTempId,
  });

  void clear();
}
