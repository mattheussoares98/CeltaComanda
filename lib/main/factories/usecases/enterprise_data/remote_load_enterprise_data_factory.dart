import '../../../../data/usecases/enterprise/enterprise.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../../../main/factories/cache/firebase_adapter_factory.dart';

LoadEnterpriseData makeRemoteLoadEnterpriseData() =>
    RemoteLoadEnterpriseData(firebaseStorage: makeFirebaseAdapter());
