import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirebaseStorage {
  Future<QuerySnapshot?> get({
    required CollectionReference<Object?> collection,
    required String fieldToSearch,
    required String valueToSearch,
  });
  Future<void> add();
  Future<void> update(QuerySnapshot querySnapshot);
}
