import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_device_imei/flutter_device_imei.dart';
import 'package:device_info_plus/device_info_plus.dart';

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
  Future<void> addDeviceInfo(DeviceInfoEntity entity, String imei) async {
    try {
      var docRef = firestore
          .collection('clients')
          .doc(EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseName)
          .collection("devices")
          .doc("loadedDevices");

      await docRef.set({
        imei: DeviceInfoModel.fromEntity(entity).toJson(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw DomainError.unexpected;
    }
  }

  @override
  Future<void> updateMenu() async {
    var docRef = firestore
        .collection('clients')
        .doc(EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseName);

    await docRef.set(
      {
        "updateMenu": FieldValue.increment(1),
      },
      SetOptions(merge: true),
    );
  }

  @override
  Future<void> addPendingDeviceToUpdate() async {
    String? identifier;
    if (Platform.isWindows) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
      identifier = windowsInfo.deviceId;
    } else {
      identifier = await FlutterDeviceImei.instance.getIMEI();
    }

    var docRef = firestore
        .collection('clients')
        .doc(EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseName);

    await docRef.set(
      {
        "pendingDevicesToUpdate": [identifier],
        "updatePendingDevices": FieldValue.increment(1),
      },
      SetOptions(merge: true),
    );
  }
}
