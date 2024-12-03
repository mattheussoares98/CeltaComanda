import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../models/models.dart';
import '../../../domain/usecases/usecases.dart';
import '../../database/database.dart';

class RemoteAddDeviceInfo implements AddDeviceInfo {
  final FirebaseStorage firebaseStorage;

  RemoteAddDeviceInfo({
    required this.firebaseStorage,
  });

  @override
  Future<void> add({
    required int? commandNumber,
    required String uniqueIdentifier,
  }) async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      final entity = DeviceInfoModel(
        commandNumber: commandNumber,
        lastUpdatedDate: DateTime.now().toIso8601String(),
        applicationVersion: packageInfo.version,
        uniqueIdentifier: uniqueIdentifier,
      ).toEntity();

      await firebaseStorage.addDeviceInfo(entity);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
