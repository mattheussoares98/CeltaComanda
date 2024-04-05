import 'package:clean_celta_mobile/data/usecases/login_data/login_data.dart';

import '../../../../domain/usecases/usecases.dart';
import '../../factories.dart';

SaveLoginData makeLocalSaveLoginData() =>
    LocalSaveLoginData(cacheStorage: makeLocalStorageAdapter());
