
import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../factories.dart';

LoadCrossId makeLocalLoadCrossId() =>
    LocalLoadCrossId(fetchSecureCacheStorage: makeSecureStorageAdapter());
