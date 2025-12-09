import '../../entities/entities.dart';

abstract class LoadDeliveryControl {
  Future<List<DeliveryControlEntity>> load(WebLocalSettingsEntity settings);
}
