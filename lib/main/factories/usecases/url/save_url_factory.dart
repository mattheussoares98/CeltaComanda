import '../../../../data/usecases/url/url.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../factories.dart';

SaveUrl makeLocalSaveUrl() => LocalSaveUrl(
      cacheStorage: makeLocalStorageAdapter(),
    );
