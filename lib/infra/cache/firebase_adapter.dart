import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/cache/cache.dart';

class FirebaseAdapter implements FirebaseStorage {
  final FirebaseFirestore firestore;

  FirebaseAdapter({required this.firestore});

  // @override
  // Future<void> add({
  //   required LoginDataEntity loginEntity,
  //   required String collection,
  // }) async {
  //   await firestore
  //       .collection(collection)
  //       .add(LoginDataModel.fromEntity(loginEntity).toFirebaseJson())
  //       .then((value) => value)
  //       .catchError((error) => error);
  // }

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
  Future<void> update(QuerySnapshot<Object?> querySnapshot) async {}
}
