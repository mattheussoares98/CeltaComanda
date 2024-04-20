import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../cache/cache.dart';

class RemoteLoginData implements LoadLoginData /* SaveLoginData */ {
  final FirebaseStorage firebaseStorage;

  RemoteLoginData({
    required this.firebaseStorage,
  });

  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;
  static final clientsCollection = _firebaseFirestore.collection(
    FirebaseCollections.clients.name,
  );

  String _getFieldToSearch(LoginDataEntity loginEntity) {
    if (kIsWeb && loginEntity.url.contains("http")) {
      return FirebaseKeys.urlWeb.name;
    } else if (loginEntity.url.contains("http")) {
      return FirebaseKeys.url.name;
    } else {
      return FirebaseKeys.enterpriseName.name;
    }
  }

  String _getValueToSearch(LoginDataEntity loginEntity) {
    if (loginEntity.url.contains("http")) {
      return loginEntity.url.toLowerCase().replaceAll(RegExp(r'\s+'), '');
    } else {
      return loginEntity.enterpriseName!
          .toLowerCase()
          .replaceAll(RegExp(r'\s+'), '');
    }
  }

  // @override
  // Future<void> add(LoginDataEntity entity) async {
  //   try {
  //     await firebaseStorage.add(
  //       loginEntity: entity,
  //       collection: FirebaseCollections.clients.name,
  //     );
  //   } catch (error) {
  //     throw DomainError.unexpected;
  //   }
  // }

  @override
  Future<LoginDataEntity?> load({LoginDataEntity? loginEntity}) async {
    if (loginEntity == null) return null;

    try {
      final querySnapshot = await firebaseStorage.get(
        collection: FirebaseCollections.clients.name,
        fieldToSearch: _getFieldToSearch(loginEntity),
        valueToSearch: _getValueToSearch(loginEntity),
      );

      if (querySnapshot.docs.isEmpty) {
        return null;
      } else {
        Map<String, dynamic> data = querySnapshot.docs[0].data();

        return LoginDataEntity(
          url: data[FirebaseKeys.url.name] ?? "",
          userName: loginEntity.userName,
          enterpriseId: data[FirebaseKeys.enterpriseId.name],
          enterpriseName: data[FirebaseKeys.enterpriseName.name] ?? "",
        );
      }
    } catch (error) {
      throw DomainError.enterpriseOrUrlNotFound;
    }
  }

  // LoginDataEntity? _mapToEntity(dynamic json) =>
  //     LoginDataModel.fromJson(json).toEntity();

  // Map _mapToJson(LoginDataEntity entity) =>
  //     LoginDataModel.fromEntity(entity).toJson();
}
