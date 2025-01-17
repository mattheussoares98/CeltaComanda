import '../../entities/entities.dart';

abstract class LoadDevicesInfo {
  Future<List<DeviceInfoEntity>> load(String enterpriseName);
}
