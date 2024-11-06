import 'package:clean_celta_mobile/domain/entities/device_info_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/database/database.dart';
import '../../data/models/models.dart';
import '../../domain/entities/print_request_entity.dart';
import '../../domain/helpers/helpers.dart';
import '../../main/builders/builders.dart';

class FirebaseAdapter implements FirebaseStorage {
  final FirebaseFirestore firestore;

  FirebaseAdapter({required this.firestore});

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> get({
    required String collection,
    required String fieldToSearch,
    required String valueToSearch,
  }) async {
    return await firestore
        .collection(collection)
        .where(fieldToSearch, isEqualTo: valueToSearch)
        .get();
  }

  @override
  Future<void> addNewPrintRequest(PrintRequestEntity entity) async {
    try {
      var agora = DateTime.now();
      var mesAnoAtual = '${agora.month}-${agora.year}';

      var docRef = firestore
          .collection('requests')
          .doc(mesAnoAtual)
          .collection("requestsInformations")
          .doc(EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseName);

      var incremento = FieldValue.increment(entity.timesUsed);
      var adicionarData = FieldValue.arrayUnion(entity.dates);

      await docRef.set({
        'printRequest': incremento,
        'dates': adicionarData,
      }, SetOptions(merge: true));
    } catch (e) {
      throw DomainError.unexpected;
    }
  }

  @override
  Future<void> addDeviceInfo(DeviceInfoEntity entity) async {
    try {
      var docRef = firestore
          .collection('clients')
          .doc(EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseName)
          .collection("devices")
          .doc("loadedDevices");

      await docRef.set({
        "${entity.id} ${entity.device}":
            DeviceInfoModel.fromEntity(entity).toJson(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}
