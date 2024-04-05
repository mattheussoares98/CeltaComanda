
import '../../../../data/usecases/login_data/login_data.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../factories.dart';

LoadLoginData makeLocalLoadLoginData() =>
    LocalLoadLoginData(cacheStorage: makeLocalStorageAdapter());
