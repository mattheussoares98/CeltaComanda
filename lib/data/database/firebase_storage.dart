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

  Future<void> updateMenu(String enterpriseName);

  Future<void> addPendingDeviceToUpdate(String imeiOrWindowsId);

  Future<void> updateEnterpriseParameters(EnterpriseEntity enterprise);

  Future<void> updateDeviceInformations(String enterpriseName);
}
