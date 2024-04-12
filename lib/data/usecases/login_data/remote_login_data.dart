import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../cache/cache.dart';

class RemoteLoginData implements LoadLoginData, SaveLoginData {
  final FirebaseStorage firebaseStorage;

  RemoteLoginData({
    required this.firebaseStorage,
  });

  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;
  static final clientsCollection = _firebaseFirestore.collection(
    FirebaseCollections.clients.name,
  );

  String _getFieldToSearch({required LoginDataEntity loginEntity}) {
    if (kIsWeb && loginEntity.url.contains("http")) {
      return FirebaseKeys.urlCCSWeb.name;
    } else if (loginEntity.url.contains("http")) {
      return FirebaseKeys.urlCCS.name;
    } else {
      return FirebaseKeys.enterpriseName.name;
    }
  }

  @override
  Future<void> add(LoginDataEntity entity) async {
    try {
      await firebaseStorage.add(
        loginEntity: entity,
        collection: FirebaseKeys.enterpriseName.name,
      );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  @override
  Future<LoginDataEntity?> load({LoginDataEntity? loginEntity}) async {
    if (loginEntity == null) return null;

    try {
      final querySnapshot = await firebaseStorage.get(
        collection: FirebaseCollections.clients.name,
        fieldToSearch: _getFieldToSearch(loginEntity: loginEntity),
        valueToSearch: loginEntity.url,
      );

      if (querySnapshot.docs.isEmpty) {
        throw DomainError.enterpriseOrUrlNotFound;
      } else {
        Map<String, dynamic> data = querySnapshot.docs[0].data();

        return LoginDataEntity(
          url: data[FirebaseKeys.urlCCS.name] ?? "",
          userName: loginEntity.userName,
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
