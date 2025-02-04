abstract class AddDeviceInfo {
  Future<void> add({
    required int? commandNumber,
    required String imeiOrWindowsId,
    required String applicationVersion,
    required String? pdvNumber,
  });
}
