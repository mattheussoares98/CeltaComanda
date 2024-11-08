import 'package:package_info_plus/package_info_plus.dart';

import '../../../data/models/models.dart';
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

      final entity = DeviceInfoModel(
        commandNumber: commandNumber,
        imei: "imei",
        lastUpdatedDate: DateTime.now().toIso8601String(),
        applicationVersion: packageInfo.version,
      ).toEntity();

      await firebaseStorage.addDeviceInfo(entity);
    } catch (e) {
      e;
    }
  }
}
