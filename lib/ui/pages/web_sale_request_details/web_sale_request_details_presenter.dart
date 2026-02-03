import 'package:flutter/material.dart';

import '../../../data/models/conc_sale_request/conc_sale_request.dart';
import '../../../domain/entities/entities.dart';
import '../../helpers/helpers.dart';

abstract class WebSaleRequestDetailsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<Map<String, ConcSaleRequestModel>> get saleRequestsStream;

  WebLocalSettingsEntity? get webLocalSettings;

  Future<void> validateEnterprise(String enterpriseName);
  Future<void> loadOpenSaleRequests();
  Future<void> updateDeliveryControlStatus({
    required int deliveryControlId,
    required IsToDelivery newStatus,
  });
}
