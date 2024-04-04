import '../../../../../data/usecases/usecases.dart';
import '../../../../../domain/usecases/usecases.dart';
import '../../factories.dart';

LoadUserName makeLocalLoadUserName() => LocalLoadUserName(
      cacheStorage: makeLocalStorageAdapter(),
    );
