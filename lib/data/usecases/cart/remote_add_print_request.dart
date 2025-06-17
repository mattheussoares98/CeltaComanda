import '../../database/database.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../mixins/mixins.dart';

class RemoteAddPrintRequest with ErrorHandling implements AddPrintRequest {
  final FirebaseStorage firebaseAdapter;

  RemoteAddPrintRequest({
    required this.firebaseAdapter,
  });

  @override
  Future<void> add(PrintRequestEntity entity) async {
    try {
      await firebaseAdapter.addNewPrintRequest(entity);
    } catch (e) {
      treatError(e);
    }
  }
}
