import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helperts.dart';
import '../../cache/cache.dart';

class LocalLoadCrossId implements LoadCrossId {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCrossId({required this.fetchSecureCacheStorage});

  @override
  Future<CrossIdEntity> load() async {
    try {
      final crossId =
          await fetchSecureCacheStorage.fetch(CacheKeys.crossId.name);
      if (crossId == null) throw Error();
      return CrossIdEntity(crossId: crossId);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
