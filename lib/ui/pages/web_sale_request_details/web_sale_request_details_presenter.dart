import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import '../../helpers/helpers.dart';

abstract class WebSaleRequestDetailsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<List<DeliveryControlEntity>> get deliveryControlsStream;

  WebLocalSettingsEntity? get webLocalSettings;

  Future<void> loadDeliveryControls();
  Future<void> validateEnterprise(String enterpriseName);
  Future<void> updateDeliveryControlStatus({
    required DeliveryControlEntity deliveryControl,
    required int? deliveryLotId,
    required IsToDelivery newStatus,
  });
}
