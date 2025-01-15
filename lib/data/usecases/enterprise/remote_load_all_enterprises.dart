import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../database/database.dart';

class RemoteLoadAllEnterprises implements LoadAllEnterprises {
  final FirebaseStorage firebaseStorage;

  RemoteLoadAllEnterprises({
    required this.firebaseStorage,
  });

  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;
  static final clientsCollection = _firebaseFirestore.collection(
    FirebaseCollections.clients.name,
  );

  @override
  Future<List<EnterpriseEntity>?> loadAll() async {
    try {
      final querySnapshot = await firebaseStorage.get(
        collection: FirebaseCollections.clients.name,
      );

      if (querySnapshot.docs.isEmpty) {
        throw Exception();
      } else {
        // Map<String, dynamic> data = querySnapshot.docs[0].data();

        // return EnterpriseValidationModel.fromJson(data).toEntity();
        //TODO treat this
        return [];
      }
    } catch (error) {
      throw DomainError.notFound;
    }
  }
}
