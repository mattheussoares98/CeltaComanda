import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../factories.dart';

UpdateEnterpriseParameters makeRemoteUpdateEnterpriseParameters() =>
    RemoteUpdateEnterpriseParameters(
      firebaseStorage: makeFirebaseAdapter(),
    );
