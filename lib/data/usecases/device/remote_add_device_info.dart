import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_device_imei/flutter_device_imei.dart';

import '../../models/models.dart';
import '../../../domain/usecases/usecases.dart';
import '../../database/database.dart';

class RemoteAddDeviceInfo implements AddDeviceInfo {
  final FirebaseStorage firebaseStorage;

  RemoteAddDeviceInfo({
    required this.firebaseStorage,
  });

  @override
  Future<void> add(int? commandNumber) async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String? imei = await FlutterDeviceImei.instance.getIMEI();

      final entity = DeviceInfoModel(
        commandNumber: commandNumber,
        lastUpdatedDate: DateTime.now().toIso8601String(),
        applicationVersion: packageInfo.version,
      ).toEntity();

      await firebaseStorage.addDeviceInfo(entity, imei ?? "unrecognizedImei");
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
