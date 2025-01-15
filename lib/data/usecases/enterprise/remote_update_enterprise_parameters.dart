import 'package:clean_celta_mobile/domain/entities/enterprise_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../database/database.dart';

class RemoteUpdateEnterpriseParameters implements UpdateEnterpriseParameters {
  final FirebaseStorage firebaseStorage;

  RemoteUpdateEnterpriseParameters({
    required this.firebaseStorage,
  });

  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;
  static final clientsCollection = _firebaseFirestore.collection(
    FirebaseCollections.clients.name,
  );

  @override
  Future<void> update(EnterpriseEntity enterprise) async {
    try {
      await firebaseStorage.updateEnterpriseParameters(enterprise);
    } catch (e) {
      throw Exception();
    }
  }
}
