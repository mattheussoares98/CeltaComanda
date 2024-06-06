import '../../cache/cache.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';

class RemoteAddPrintRequest implements AddPrintRequest {
  final FirebaseStorage firebaseAdapter;

  RemoteAddPrintRequest({
    required this.firebaseAdapter,
  });

  @override
  Future<void> add(PrintRequestEntity entity) async {
    try {
      await firebaseAdapter.addNewPrintRequest(entity);
    } catch (e) {
      throw Exception();
    }
  }
}
