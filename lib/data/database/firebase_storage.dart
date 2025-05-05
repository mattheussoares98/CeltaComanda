import '../../domain/entities/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirebaseStorage {
  Future<QuerySnapshot<Map<String, dynamic>>> get({
    required String collection,
    String? fieldToSearch,
    String? valueToSearch,
  });

  Future<void> addNewPrintRequest(PrintRequestEntity entity);

  Future<void> addDeviceInfo(DeviceInfoEntity entity);
  Future<List<DeviceInfoEntity>> loadDeviceInfo(String enterpriseId);

  Future<void> updateMenu(String enterpriseId);

  Future<void> addPendingDeviceToUpdate({
    required String imeiOrWindowsId,
    required String enterpriseId,
  });

  Future<void> updateEnterpriseParameters(EnterpriseEntity enterprise);

  Future<void> updateDeviceInformations(String enterpriseId);

  Future<void> deleteEnterprise(String enterpriseId);
}
