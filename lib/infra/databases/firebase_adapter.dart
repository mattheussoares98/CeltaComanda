import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/database/database.dart';
import '../../data/models/models.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../main/builders/builders.dart';

class FirebaseAdapter implements FirebaseStorage {
  final FirebaseFirestore firestore;

  FirebaseAdapter({required this.firestore});

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> get({
    required String collection,
    String? fieldToSearch,
    String? valueToSearch,
  }) async {
    if (fieldToSearch == null || valueToSearch == null) {
      return await firestore.collection(collection).get();
    } else {
      return await firestore
          .collection(collection)
          .where(fieldToSearch, isEqualTo: valueToSearch)
          .get();
    }
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
          .doc(EnterpriseBuilder.entity!.enterpriseName);

      var incremento = FieldValue.increment(entity.timesUsed);
      var adicionarData = FieldValue.arrayUnion(entity.dates);

      await docRef.set({
        'printRequest': incremento,
        'dates': adicionarData,
      }, SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addDeviceInfo(DeviceInfoEntity entity) async {
    try {
      var docRef = firestore
          .collection('clients')
          .doc(EnterpriseBuilder.entity!.enterpriseName)
          .collection("devices")
          .doc("loadedDevices");

      await docRef.set({
        entity.imeiOrWindowsId: DeviceInfoModel.fromEntity(entity).toJson(),
      }, SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<DeviceInfoEntity>> loadDeviceInfo(String enterpriseName) async {
    try {
      var docRef = firestore
          .collection('clients')
          .doc(enterpriseName)
          .collection("devices")
          .doc("loadedDevices");

      final value = await docRef.get();

      if (value.data() == null) {
        throw DomainError.notFound;
      }

      List<DeviceInfoEntity> devices = value
          .data()!
          .values
          .map((data) => DeviceInfoModel.fromJson(data).toEntity())
          .toList();

      return devices;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateMenu(String enterpriseName) async {
    var docRef = firestore.collection('clients').doc(enterpriseName);

    await docRef.set(
      {
        "updatePendingDevices": FieldValue.increment(1),
        "pendingDevicesToUpdate": [],
      },
      SetOptions(merge: true),
    );

    await Future.delayed(Duration(seconds: 10));

    await docRef.set(
      {
        "updateMenu": FieldValue.increment(1),
      },
      SetOptions(merge: true),
    );
  }

  @override
  Future<void> addPendingDeviceToUpdate({
    required String imeiOrWindowsId,
    required String enterpriseName,
  }) async {
    var docRef = firestore.collection('clients').doc(enterpriseName);

    await docRef.set(
      {
        "pendingDevicesToUpdate": FieldValue.arrayUnion([imeiOrWindowsId]),
      },
      SetOptions(merge: true),
    );
  }

  @override
  Future<void> updateEnterpriseParameters(EnterpriseEntity enterprise) async {
    try {
      var docRef =
          firestore.collection('clients').doc(enterprise.firebaseEnterpriseId);

      await docRef.set(
        EnterpriseModel.fromEntity(enterprise).toJson(),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateDeviceInformations(String enterpriseName) async {
    try {
      var docRef = firestore.collection('clients').doc(enterpriseName);
      var devicesRef = docRef.collection("devices").doc("loadedDevices");
      await devicesRef.delete();

      await docRef.set(
        {
          "updateDevicesInformations": FieldValue.increment(1),
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteEnterprise(String enterpriseName) async {
    try {
      var docRef = firestore.collection('clients').doc(enterpriseName);
      await docRef.delete();
    } catch (e) {
      rethrow;
    }
  }
}
