import '../../../data/usecases/save_url/save_url.dart';
import '../../../domain/usecases/usecases.dart';
import '../factories.dart';

SaveUrl makeLocalSaveUrl() => LocalSaveUrl(
      cacheStorage: makeLocalStorageAdapter(),
    );
