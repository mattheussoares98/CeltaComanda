import '../../../../data/usecases/cross_id/cross_id.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../factories.dart';

SaveCrossId makeLocalSaveCrossId() =>
    LocalSaveCrossId(saveSecureCacheStorage: makeSecureStorageAdapter());
