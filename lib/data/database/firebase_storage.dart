import '../../domain/entities/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirebaseStorage {
  Future<QuerySnapshot<Map<String, dynamic>>> get({
    required String collection,
    required String fieldToSearch,
    required String valueToSearch,
  });

  Future<void> addNewPrintRequest(PrintRequestEntity entity);

  Future<void> addDeviceInfo(DeviceInfoEntity entity, String imei);

  Future<void> updateMenu();

  Future<void> addPendingDeviceToUpdate(String uniqueIdentifier);
}
