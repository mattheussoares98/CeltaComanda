import 'package:clean_celta_mobile/main/factories/cache/firebase_adapter_factory.dart';

import '../../../../data/usecases/login_data/login_data.dart';

RemoteLoginData makeRemoteLoginData() =>
    RemoteLoginData(firebaseStorage: makeFirebaseAdapter());
