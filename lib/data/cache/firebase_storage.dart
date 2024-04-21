// import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirebaseStorage {
  Future<QuerySnapshot<Map<String, dynamic>>> get({
    required String collection,
    required String fieldToSearch,
    required String valueToSearch,
  });

  Future<void> update(QuerySnapshot querySnapshot);
}
