import '../../../data/cache/cache.dart';
import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';

class RemoteAddPrintRequest implements AddPrintRequest {
  final FirebaseStorage firebaseAdapter;
  final LocalPrintRequest localPrintRequest;

  RemoteAddPrintRequest({
    required this.firebaseAdapter,
    required this.localPrintRequest,
  });

  @override
  Future<void> add() async {
    try {
      final localData = await localPrintRequest.getMergedPrintedEntity();

      await firebaseAdapter.addNewPrintRequest(localData);
      await localPrintRequest.clear();
    } catch (e) {
      await localPrintRequest.add();
    }
  }
}
