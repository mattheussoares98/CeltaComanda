import '../../entities/entities.dart';

abstract class UpdateDeliveryStatus {
  Future<void> update({
    required WebLocalSettingsEntity settings,
    required int id,
    required IsToDelivery newStatus,
    OriginType? originType = OriginType.saleRequest,
  });
}

enum OriginType {
  saleMovement(1),
  saleRequest(2);

  final int value;
  const OriginType(this.value);
}
