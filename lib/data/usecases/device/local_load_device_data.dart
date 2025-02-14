import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_device_imei/flutter_device_imei.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../domain/usecases/usecases.dart';

class LocalLoadimeiOrWindowsId implements LoadDeviceData {
  @override
  Future<String> getImeiOrWindowsId() async {
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

  @override
  Future<String> getApplicationVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    } catch (e) {
      return "unrecognized";
    }
  }

  @override
  bool isAndroidPlatform() {
    return Platform.isAndroid;
  }

  @override
  bool isIOSPlatform() {
    return Platform.isIOS;
  }
}
