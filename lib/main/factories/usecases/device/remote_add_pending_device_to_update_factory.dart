import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../factories.dart';

AddPendingDeviceToUpdate makeRemoteAddPendingDeviceToUpdate() =>
    RemoteAddPendingDeviceToUpdate(
      firebaseStorage: makeFirebaseAdapter(),
    );
