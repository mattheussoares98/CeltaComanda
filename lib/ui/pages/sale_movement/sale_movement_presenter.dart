import 'package:flutter/material.dart';

import '../../../data/models/models.dart';
import '../../helpers/helpers.dart';

abstract class SaleMovementPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<List<SaleMovementConcentratorModel>?> get salesStream;

  Future<void> loadSales({required String date});
}
