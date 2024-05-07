import '../../../../data/usecases/enterprise/enterprise.dart';
import '../../../../main/factories/cache/firebase_adapter_factory.dart';

RemoteEnterpriseData makeRemoteEnterpriseData() =>
    RemoteEnterpriseData(firebaseStorage: makeFirebaseAdapter());
