import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helperts.dart';
import '../../cache/cache.dart';

class LocalSaveCrossId implements SaveCrossId {
  final SaveSecureCacheStorage saveSecureCacheStorage;

  LocalSaveCrossId({required this.saveSecureCacheStorage});

  @override
  Future<void> save(CrossIdEntity? account) async {
    try {
      if (account != null) {
        await saveSecureCacheStorage.save(
          key: CacheKeys.crossId.name,
          value: account.crossId,
        );
      } else {
        throw DomainError.unexpected;
      }
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
