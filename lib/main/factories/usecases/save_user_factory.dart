import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../factories.dart';

SaveUser makeLocalSaveUser() => LocalSaveUser(
      cacheStorage: makeLocalStorageAdapter(),
    );
