import 'dart:io';

import 'package:clean_celta_mobile/presentation/helpers/app_platform.dart';
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
    } else if (Platform.isMacOS) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      MacOsDeviceInfo macosInfo = await deviceInfo.macOsInfo;
      identifier = macosInfo.systemGUID;
    } else {
      identifier = await FlutterDeviceImei.instance.getIMEI();
    }

    if (activePlatform.isPaymentPlatform) {
      return "${activePlatform.name} - ${identifier ?? ""}";
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
