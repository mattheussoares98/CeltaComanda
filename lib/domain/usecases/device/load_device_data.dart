abstract class LoadDeviceData {
  Future<String> getImeiOrWindowsId();
  Future<String> getApplicationVersion();
  bool isAndroidPlatform();
  bool isIOSPlatform();
}
