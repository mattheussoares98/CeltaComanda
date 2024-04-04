import '../../../../domain/helpers/helpers.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../../../infra/helpers/helperts.dart';
import '../../../cache/cache.dart';

class LocalSaveUrl implements SaveUrl {
  final CacheStorage cacheStorage;

  LocalSaveUrl({required this.cacheStorage});

  @override
  Future<void> save(String url) async {
    try {
      await cacheStorage.save(key: CacheKeys.url.name, value: url);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
