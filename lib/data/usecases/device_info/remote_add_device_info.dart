import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

import '../../../data/models/models.dart';
import '../../../domain/usecases/usecases.dart';
import '../../database/database.dart';

class RemoteAddDeviceInfo implements AddDeviceInfo {
  final FirebaseStorage firebaseStorage;

  RemoteAddDeviceInfo({
    required this.firebaseStorage,
  });

  @override
  Future<void> add() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo? androidInfo;
      IosDeviceInfo? iosInfo;

      if (Platform.isAndroid) {
        androidInfo = await deviceInfo.androidInfo;
        final entity = DeviceInfoModel.fromJson(androidInfo.data).toEntity();
        await firebaseStorage.addDeviceInfo(entity);
      } else if (Platform.isIOS) {
        iosInfo = await deviceInfo.iosInfo;
        final entity = DeviceInfoModel.fromJson(iosInfo.data).toEntity();
        await firebaseStorage.addDeviceInfo(entity);
      }
    } catch (e) {
      e;
    }
  }
}
