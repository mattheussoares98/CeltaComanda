import 'package:clean_celta_mobile/data/cache/cache.dart';
import 'package:clean_celta_mobile/domain/helpers/domain_error.dart';
import 'package:clean_celta_mobile/domain/usecases/sale_request_temp/sale_request_temp.dart';

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
