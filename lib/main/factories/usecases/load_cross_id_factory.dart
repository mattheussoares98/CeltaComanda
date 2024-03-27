import '../../../data/usecases/load_cross_id/local_load_cross_id.dart';
import '../../../domain/usecases/usecases.dart';
import '../factories.dart';

LoadCrossId makeLocalLoadCrossId() =>
    LocalLoadCrossId(fetchSecureCacheStorage: makeSecureStorageAdapter());
