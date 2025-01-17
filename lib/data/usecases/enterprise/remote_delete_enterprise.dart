import '../../../domain/usecases/usecases.dart';
import '../../database/database.dart';

class RemoteDeleteEnterprise implements DeleteEnterprise {
  final FirebaseStorage firebaseAdapter;

  RemoteDeleteEnterprise({
    required this.firebaseAdapter,
  });

  @override
  Future<void> delete(String enterpriseName) async {
    try {
      await firebaseAdapter.deleteEnterprise(enterpriseName);
    } catch (e) {
      throw Exception();
    }
  }
}
