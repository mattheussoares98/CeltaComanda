import 'package:flutter/material.dart';

import '../../../data/models/models.dart';
import '../../helpers/helpers.dart';

abstract class WebSaleRequestDetailsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<List<SaleRequestModel>> get saleRequestsStream;

  Future<void> validateEnterprise(String enterpriseName);
  Future<void> loadOpenSaleRequests({required bool isConsiderDelivered});
}
