import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_device_imei/flutter_device_imei.dart';

import '../../../domain/usecases/usecases.dart';

class LocalLoadUniqueIdentifier implements LoadUniqueIdentifier {
  @override
  Future<String> get() async {
    String? identifier;
    if (Platform.isWindows) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
      identifier = windowsInfo.deviceId;
    } else {
      identifier = await FlutterDeviceImei.instance.getIMEI();
    }

    return identifier ?? "";
  }
}
