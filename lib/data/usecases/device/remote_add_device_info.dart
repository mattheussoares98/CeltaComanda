import 'package:flutter/foundation.dart';

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
    required String imeiOrWindowsId,
    required String applicationVersion,
  }) async {
    try {
      final entity = DeviceInfoModel(
        commandNumber: commandNumber,
        lastUpdatedDate: DateTime.now().toIso8601String(),
        applicationVersion: applicationVersion,
        imeiOrWindowsId: imeiOrWindowsId, //TODO add battery information
      ).toEntity();

      await firebaseStorage.addDeviceInfo(entity);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
