import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../../ui/helpers/helpers.dart';
import '../../database/database.dart';
import '../../models/models.dart';

class RemoteLoadEnterpriseData implements LoadEnterpriseData {
  final FirebaseStorage firebaseStorage;

  RemoteLoadEnterpriseData({
    required this.firebaseStorage,
  });

  @override
  Future<EnterpriseEntity?> load() async {
    try {
      final querySnapshot = await firebaseStorage.get(
        collection: FirebaseCollections.clients.name,
        fieldToSearch: FirebaseKeys.enterpriseName.name,
        valueToSearch: EnterpriseBuilder.entity!.enterpriseName
            .toLowerCase()
            .removeWhiteSpaces(),
      );

      if (querySnapshot.docs.isEmpty) {
        return null;
      } else {
        Map<String, dynamic> data = querySnapshot.docs[0].data();

        return EnterpriseModel.fromJson(data).toEntity();
      }
    } catch (error) {
      throw DomainError.enterpriseOrUrlNotFound;
    }
  }
}
