import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import '../../data/database/database.dart';
import '../../data/models/models.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../main/builders/builders.dart';

class FirebaseAdapter implements FirebaseStorage {
  final FirebaseFirestore firestore;

  FirebaseAdapter({required this.firestore});

  static const _firestoreBaseUrl =
      'https://firestore.googleapis.com/v1/projects/celta-restaurant/databases/(default)/documents';

  dynamic _parseValue(dynamic val) {
    if (val is! Map) return val;
    final keys = val.keys;
    if (keys.isEmpty) return null;
    final typeKey = keys.first;
    final value = val[typeKey];

    switch (typeKey) {
      case 'stringValue':
        return value as String;
      case 'integerValue':
        return int.tryParse(value.toString()) ?? 0;
      case 'doubleValue':
        return double.tryParse(value.toString()) ?? 0.0;
      case 'booleanValue':
        return value as bool;
      case 'timestampValue':
        return value as String;
      case 'mapValue':
        final fields = (value as Map)['fields'] as Map?;
        if (fields == null) return <String, dynamic>{};
        return fields.map((k, v) => MapEntry(k as String, _parseValue(v)));
      case 'arrayValue':
        final values = (value as Map)['values'] as List?;
        if (values == null) return [];
        return values.map((v) => _parseValue(v)).toList();
      case 'nullValue':
      default:
        return null;
    }
  }

  Map<String, dynamic> _convertToFirestoreValue(dynamic val) {
    if (val == null) {
      return {'nullValue': null};
    } else if (val is String) {
      return {'stringValue': val};
    } else if (val is bool) {
      return {'booleanValue': val};
    } else if (val is int) {
      return {'integerValue': val.toString()};
    } else if (val is double) {
      return {'doubleValue': val};
    } else if (val is Map) {
      final Map<String, dynamic> fields = {};
      val.forEach((k, v) {
        fields[k.toString()] = _convertToFirestoreValue(v);
      });
      return {
        'mapValue': {'fields': fields}
      };
    } else if (val is List) {
      final List<dynamic> values = val.map((v) => _convertToFirestoreValue(v)).toList();
      return {
        'arrayValue': {'values': values}
      };
    } else {
      return {'stringValue': val.toString()};
    }
  }

  Future<Map<String, dynamic>?> _getRestDocument(String path) async {
    try {
      final url = '$_firestoreBaseUrl/$path';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final fieldsJson = body['fields'] as Map<String, dynamic>? ?? {};
        final Map<String, dynamic> parsedData = {};
        fieldsJson.forEach((key, val) {
          parsedData[key] = _parseValue(val);
        });
        return parsedData;
      }
    } catch (e) {
      // Ignore
    }
    return null;
  }

  Future<bool> _patchRestDocument(String path, Map<String, dynamic> data) async {
    try {
      final url = '$_firestoreBaseUrl/$path';
      final fields = <String, dynamic>{};
      data.forEach((k, v) {
        fields[k] = _convertToFirestoreValue(v);
      });
      final body = jsonEncode({
        'fields': fields,
      });
      final response = await http.patch(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      return response.statusCode == 200;
    } catch (e) {
      // Ignore
    }
    return false;
  }

  Future<bool> _deleteRestDocument(String path) async {
    try {
      final url = '$_firestoreBaseUrl/$path';
      final response = await http.delete(Uri.parse(url));
      return response.statusCode == 200;
    } catch (e) {
      // Ignore
    }
    return false;
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> get({
    required String collection,
    String? fieldToSearch,
    String? valueToSearch,
  }) async {
    if (!kIsWeb && Platform.isWindows) {
      try {
        final url = '$_firestoreBaseUrl/$collection';
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final body = jsonDecode(response.body) as Map<String, dynamic>;
          final documentsJson = body['documents'] as List? ?? [];
          
          final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = [];
          for (var docJson in documentsJson) {
            final docMap = docJson as Map<String, dynamic>;
            final name = docMap['name'] as String? ?? '';
            final id = name.split('/').last;
            final fieldsJson = docMap['fields'] as Map<String, dynamic>? ?? {};
            
            final Map<String, dynamic> parsedData = {};
            fieldsJson.forEach((key, val) {
              parsedData[key] = _parseValue(val);
            });
            
            if (fieldToSearch == null || valueToSearch == null || parsedData[fieldToSearch] == valueToSearch) {
              docs.add(InMemoryQueryDocumentSnapshot(id, parsedData));
            }
          }
          
          return InMemoryQuerySnapshot(docs);
        }
      } catch (e) {
        // Fallback below if REST fails
      }
    }

    if (fieldToSearch == null || valueToSearch == null) {
      return await firestore.collection(collection).get();
    } else {
      if (!kIsWeb && Platform.isWindows) {
        // Workaround for Windows native C++ Firestore crash on .where() queries
        final fullSnapshot = await firestore.collection(collection).get();
        final filteredDocs = fullSnapshot.docs.where((doc) {
          final data = doc.data();
          return data[fieldToSearch] == valueToSearch;
        }).toList();
        return FilteredQuerySnapshot(fullSnapshot, filteredDocs);
      } else {
        return await firestore
            .collection(collection)
            .where(fieldToSearch, isEqualTo: valueToSearch)
            .get();
      }
    }
  }

  @override
  Future<void> addNewPrintRequest(PrintRequestEntity entity) async {
    if (!kIsWeb && Platform.isWindows) {
      try {
        var agora = DateTime.now();
        var mesAnoAtual = '${agora.month}-${agora.year}';
        final path = 'requests/$mesAnoAtual/requestsInformations/${EnterpriseBuilder.entity!.enterpriseName}';
        
        final current = await _getRestDocument(path) ?? {};
        final int currentCount = (current['printRequest'] as num?)?.toInt() ?? 0;
        final List<dynamic> currentDates = current['dates'] as List? ?? [];
        
        final newDates = List<dynamic>.from(currentDates);
        for (var date in entity.dates) {
          if (!newDates.contains(date)) {
            newDates.add(date);
          }
        }
        
        final success = await _patchRestDocument(path, {
          'printRequest': currentCount + entity.timesUsed,
          'dates': newDates,
        });
        if (success) return;
      } catch (e) {
        // Fallback below
      }
    }

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
    if (!kIsWeb && Platform.isWindows) {
      try {
        final path = 'clients/${EnterpriseBuilder.entity!.enterpriseName}/devices/loadedDevices';
        final current = await _getRestDocument(path) ?? {};
        current[entity.imeiOrWindowsId] = DeviceInfoModel.fromEntity(entity).toJson();
        final success = await _patchRestDocument(path, current);
        if (success) return;
      } catch (e) {
        // Fallback below
      }
    }

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
      if (!kIsWeb && Platform.isWindows) {
        final path = 'clients/$enterpriseName/devices/loadedDevices';
        final parsedData = await _getRestDocument(path);
        if (parsedData == null) {
          throw DomainError.notFound;
        }
        
        List<DeviceInfoEntity> devices = parsedData.values
            .map((data) => DeviceInfoModel.fromJson(data as Map).toEntity())
            .toList();
        return devices;
      } else {
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
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateMenu(String enterpriseName) async {
    if (!kIsWeb && Platform.isWindows) {
      try {
        final path = 'clients/$enterpriseName';
        
        final current1 = await _getRestDocument(path) ?? {};
        final int currentPending = (current1['updatePendingDevices'] as num?)?.toInt() ?? 0;
        final success1 = await _patchRestDocument(path, {
          'updatePendingDevices': currentPending + 1,
          'pendingDevicesToUpdate': [],
        });
        
        if (success1) {
          await Future.delayed(const Duration(seconds: 10));
          
          final current2 = await _getRestDocument(path) ?? {};
          final int currentUpdateMenu = (current2['updateMenu'] as num?)?.toInt() ?? 0;
          await _patchRestDocument(path, {
            'updateMenu': currentUpdateMenu + 1,
          });
          return;
        }
      } catch (e) {
        // Fallback below
      }
    }

    var docRef = firestore.collection('clients').doc(enterpriseName);

    await docRef.set(
      {
        "updatePendingDevices": FieldValue.increment(1),
        "pendingDevicesToUpdate": [],
      },
      SetOptions(merge: true),
    );

    await Future.delayed(const Duration(seconds: 10));

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
    if (!kIsWeb && Platform.isWindows) {
      try {
        final path = 'clients/$enterpriseName';
        final current = await _getRestDocument(path) ?? {};
        final List<dynamic> currentPending = current['pendingDevicesToUpdate'] as List? ?? [];
        final newPending = List<dynamic>.from(currentPending);
        if (!newPending.contains(imeiOrWindowsId)) {
          newPending.add(imeiOrWindowsId);
        }
        final success = await _patchRestDocument(path, {
          'pendingDevicesToUpdate': newPending,
        });
        if (success) return;
      } catch (e) {
        // Fallback below
      }
    }

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
    if (!kIsWeb && Platform.isWindows) {
      try {
        final path = 'clients/${enterprise.enterpriseName}';
        final success = await _patchRestDocument(
          path,
          EnterpriseModel.fromEntity(enterprise).toJson(),
        );
        if (success) return;
      } catch (e) {
        // Fallback below
      }
    }

    try {
      var docRef =
          firestore.collection('clients').doc(enterprise.enterpriseName);

      await docRef.set(
        EnterpriseModel.fromEntity(enterprise).toJson(),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateDeviceInformations(String enterpriseName) async {
    if (!kIsWeb && Platform.isWindows) {
      try {
        final docPath = 'clients/$enterpriseName';
        final devicesPath = 'clients/$enterpriseName/devices/loadedDevices';
        
        await _deleteRestDocument(devicesPath);
        
        final current = await _getRestDocument(docPath) ?? {};
        final int currentUpdate = (current['updateDevicesInformations'] as num?)?.toInt() ?? 0;
        final success = await _patchRestDocument(docPath, {
          'updateDevicesInformations': currentUpdate + 1,
        });
        if (success) return;
      } catch (e) {
        // Fallback below
      }
    }

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
    if (!kIsWeb && Platform.isWindows) {
      try {
        final path = 'clients/$enterpriseName';
        final success = await _deleteRestDocument(path);
        if (success) return;
      } catch (e) {
        // Fallback below
      }
    }

    try {
      var docRef = firestore.collection('clients').doc(enterpriseName);
      await docRef.delete();
    } catch (e) {
      rethrow;
    }
  }
}

class FilteredQuerySnapshot<T> implements QuerySnapshot<T> {
  final QuerySnapshot<T> _original;
  @override
  final List<QueryDocumentSnapshot<T>> docs;

  FilteredQuerySnapshot(this._original, this.docs);

  @override
  List<DocumentChange<T>> get docChanges => _original.docChanges;

  @override
  SnapshotMetadata get metadata => _original.metadata;

  @override
  int get size => docs.length;
}

class InMemoryQuerySnapshot implements QuerySnapshot<Map<String, dynamic>> {
  @override
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;

  InMemoryQuerySnapshot(this.docs);

  @override
  List<DocumentChange<Map<String, dynamic>>> get docChanges => const [];

  @override
  SnapshotMetadata get metadata => throw UnimplementedError();

  @override
  int get size => docs.length;
}

// ignore: subtype_of_sealed_class
class InMemoryQueryDocumentSnapshot implements QueryDocumentSnapshot<Map<String, dynamic>> {
  final Map<String, dynamic> _data;
  @override
  final String id;

  InMemoryQueryDocumentSnapshot(this.id, this._data);

  @override
  Map<String, dynamic> data() => _data;

  @override
  bool get exists => true;

  @override
  dynamic get(Object field) => _data[field];

  @override
  dynamic operator [](Object field) => _data[field];

  @override
  DocumentReference<Map<String, dynamic>> get reference => throw UnimplementedError();

  @override
  SnapshotMetadata get metadata => throw UnimplementedError();
}
