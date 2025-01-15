import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../database/database.dart';
import '../../models/models.dart';

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
  Future<List<EnterpriseEntity>?> load() async {
    try {
      final querySnapshot = await firebaseStorage.get(
        collection: FirebaseCollections.clients.name,
      );

      if (querySnapshot.docs.isEmpty) {
        throw Exception();
      } else {
        return querySnapshot.docs
            .map((e) => EnterpriseValidationModel.fromJson(e.data()).toEntity())
            .toList();
      }
    } catch (error) {
      throw DomainError.notFound;
    }
  }
}
