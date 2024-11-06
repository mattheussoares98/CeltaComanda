import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

import '../../../data/models/models.dart';
import '../../../domain/entities/device_info_entity.dart';
import '../../../domain/usecases/usecases.dart';

class LocalLoadDeviceInfo implements LoadDeviceInfo {
  @override
  Future<DeviceInfoEntity?> get() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo? androidInfo;
      IosDeviceInfo? iosInfo;

      if (Platform.isAndroid) {
        androidInfo = await deviceInfo.androidInfo;
        return DeviceInfoModel.fromJson(androidInfo.data).toEntity();
      } else if (Platform.isIOS) {
        iosInfo = await deviceInfo.iosInfo;
        return DeviceInfoModel.fromJson(iosInfo.data).toEntity();
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
