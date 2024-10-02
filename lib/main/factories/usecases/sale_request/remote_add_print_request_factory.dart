import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../factories.dart';

AddPrintRequest makeRemoteAddPrintRequest() => RemoteAddPrintRequest(
      firebaseAdapter: makeFirebaseAdapter(),
    );
