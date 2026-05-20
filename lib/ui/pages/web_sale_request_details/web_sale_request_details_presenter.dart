import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import '../../helpers/helpers.dart';

abstract class WebSaleRequestDetailsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<Map<String, PrintedEntity>> get saleRequestsStream;
  Stream<List<DeliveryControlEntity>> get deliveryControlsStream;

  WebLocalSettingsEntity? get webLocalSettings;

  Future<void> loadDeliveryControls();
  Future<void> validateEnterprise(String enterpriseName);
  Future<void> loadOpenSaleRequests();
  Future<void> updateDeliveryControlStatus({
    required int saleRequestId,
    required int deliveryLotId,
    required IsToDelivery newStatus,
  });
}
