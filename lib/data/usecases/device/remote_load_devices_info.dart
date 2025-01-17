import 'package:clean_celta_mobile/domain/entities/device_info_entity.dart';

import '../../../domain/usecases/usecases.dart';
import '../../database/database.dart';

class RemoteLoadDevicesInfo implements LoadDevicesInfo {
  final FirebaseStorage firebaseStorage;

  RemoteLoadDevicesInfo({
    required this.firebaseStorage,
  });

  @override
  Future<List<DeviceInfoEntity>> load(String enterpriseName) async {
    try {
      return await firebaseStorage.loadDeviceInfo(enterpriseName);
    } catch (e) {
      rethrow;
    }
  }
}
