import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../../ui/helpers/helpers.dart';
import '../../cache/cache.dart';
import '../../models/models.dart';

class RemoteEnterpriseData implements LoadEnterpriseData {
  final FirebaseStorage firebaseStorage;

  RemoteEnterpriseData({
    required this.firebaseStorage,
  });

  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;
  static final clientsCollection = _firebaseFirestore.collection(
    FirebaseCollections.clients.name,
  );

  @override
  Future<EnterpriseEntity?> load() async {
    try {
      final querySnapshot = await firebaseStorage.get(
        collection: FirebaseCollections.clients.name,
        fieldToSearch: FirebaseKeys.enterpriseName.name,
        valueToSearch: EnterpriseDataBuilder
            .enterpriseDataEntity!.enterpriseName
            .toLowerCase()
            .removeWhiteSpaces(),
      );

      if (querySnapshot.docs.isEmpty) {
        return null;
      } else {
        Map<String, dynamic> data = querySnapshot.docs[0].data();

        return EnterpriseValidationModel.fromJson(data).toEntity();
      }
    } catch (error) {
      throw DomainError.enterpriseOrUrlNotFound;
    }
  }
}
