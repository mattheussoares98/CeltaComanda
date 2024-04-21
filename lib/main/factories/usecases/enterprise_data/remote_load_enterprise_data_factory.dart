import 'package:clean_celta_mobile/main/factories/cache/firebase_adapter_factory.dart';

import '../../../../data/usecases/enterprise/enterprise.dart';

RemoteEnterpriseData makeRemoteEnterpriseData() =>
    RemoteEnterpriseData(firebaseStorage: makeFirebaseAdapter());
