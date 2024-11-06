import '../../entities/entities.dart';

abstract class LoadDeviceInfo {
  Future<DeviceInfoEntity?> get();
}
