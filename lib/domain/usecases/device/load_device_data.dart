abstract class LoadDeviceData {
  Future<String> getImeiOrWindowsId({required bool isRedeVersion});
  Future<String> getApplicationVersion();
  bool isAndroidPlatform();
  bool isIOSPlatform();
}
