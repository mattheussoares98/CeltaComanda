import '../../entities/entities.dart';

abstract class ConcDeliveryControl {
  Future<void> update({
    required WebLocalSettingsEntity settings,
    required int saleRequestId,
    required int deliveryLoteNumber,
    required IsToDelivery newStatus,
    OriginType? originType = OriginType.saleRequest,
  });
  Future<List<DeliveryControlEntity>> load(WebLocalSettingsEntity settings);
  Future<List<DeliveryControlEntity>> loadWithProducts(
    WebLocalSettingsEntity settings,
  );
}

enum OriginType {
  saleMovement(1),
  saleRequest(2);

  final int value;
  const OriginType(this.value);
}
