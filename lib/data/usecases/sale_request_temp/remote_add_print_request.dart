import '../../../data/cache/cache.dart';
import '../../../domain/helpers/domain_error.dart';
import '../../../domain/usecases/usecases.dart';

class RemoteAddPrintRequest implements AddPrintRequest {
  final FirebaseStorage firebaseAdapter;

  RemoteAddPrintRequest({required this.firebaseAdapter});

  @override
  Future<void> add() async {
    try {
      await firebaseAdapter.addNewPrintRequest();
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}
