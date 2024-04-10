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

  String _getFieldToSearch({required LoginDataEntity loginData}) {
    if (kIsWeb && loginData.url.contains("http")) {
      return "urlCCSWeb";
    } else if (loginData.url.contains("http")) {
      return "urlCCs";
    } else {
      return "enterpriseName";
    }
  }

  @override
  Future<void> save(LoginDataEntity entity) async {
    try {
      // final json = _mapToJson(entity);
      // await hiveStorage.put(
      //   CacheKeys.loginData.name,
      //   json,
      // );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  @override
  Future<LoginDataEntity?> load({LoginDataEntity? loginData}) async {
    if (loginData == null) return null;
    
    try {
      final querySnapshot = await firebaseStorage.get(
        collection: FirebaseCollections.clients.name,
        fieldToSearch: _getFieldToSearch(loginData: loginData),
        valueToSearch: loginData.url,
      );

      if (querySnapshot.docs.isEmpty) {
        throw DomainError.enterpriseOrUrlNotFound;
      } else {
        Map<String, dynamic> data = querySnapshot.docs[0].data();

        return LoginDataEntity(
          url: data[FirebaseKeys.urlCCS.name] ?? "",
          userName: "userName",
          enterpriseName: data[FirebaseKeys.enterpriseName.name] ?? "",
        );
      }
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  // LoginDataEntity? _mapToEntity(dynamic json) =>
  //     LoginDataModel.fromJson(json).toEntity();

  // Map _mapToJson(LoginDataEntity entity) =>
  //     LoginDataModel.fromEntity(entity).toJson();
}
