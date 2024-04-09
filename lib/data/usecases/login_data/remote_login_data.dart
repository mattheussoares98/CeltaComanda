import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../cache/cache.dart';

class RemoteLoginData
    implements LoadLoginData, SaveLoginData, ValidateLoginData {
  final FirebaseStorage firebaseStorage;
  final LoginDataEntity loginDataEntity;

  RemoteLoginData({
    required this.firebaseStorage,
    required this.loginDataEntity,
  });

  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;
  static final clientsCollection = _firebaseFirestore.collection(
    FirebaseCollections.clients.name,
  );

  String _getFieldToSearch() {
    if (kIsWeb && loginDataEntity.url.contains("http")) {
      return "urlCCSWeb";
    } else if (loginDataEntity.url.contains("http")) {
      return "urlCCs";
    } else {
      return "enterpriseName";
    }
  }

  @override
  Future<LoginDataEntity?> load() async {
    try {
      final querySnapshot = await firebaseStorage.get(
        collection:
            _firebaseFirestore.collection(FirebaseCollections.clients.name),
        fieldToSearch: _getFieldToSearch(),
        valueToSearch: loginDataEntity.url,
      );

      if (querySnapshot == null) {
        throw DomainError.enterpriseOrUrlNotFound;
      } else {
        Map<String, dynamic> data =
            querySnapshot.docs[0].data() as Map<String, dynamic>;

        return LoginDataEntity(
          url: data[FirebaseKeys.urlCCS.name] ?? "",
          userName: loginDataEntity.userName,
        );
      }
    } catch (error) {
      throw DomainError.unexpected;
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
  Future<void> validate() async {
    // try {
    //   final data = await hiveStorage.get(
    //     CacheKeys.loginData.name,
    //   );
    //   _mapToEntity(data);
    // } catch (error) {
    //   await hiveStorage.delete(
    //     CacheKeys.loginData.name,
    //   );
    // }
  }

  // LoginDataEntity? _mapToEntity(dynamic json) =>
  //     LoginDataModel.fromJson(json).toEntity();

  // Map _mapToJson(LoginDataEntity entity) =>
  //     LoginDataModel.fromEntity(entity).toJson();
}
