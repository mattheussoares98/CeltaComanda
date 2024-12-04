abstract class LoadDeviceData {
  Future<String> getImeiOrWindowsId();
  Future<String> getApplicationVersion();
}
