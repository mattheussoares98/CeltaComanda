import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../cache/cache.dart';

class LocalSaveUrl implements SaveUrl {
  final CacheStorage cacheStorage;

  LocalSaveUrl({required this.cacheStorage});

  @override
  Future<void> save(String url) async {
    try {
      await cacheStorage.save(key: 'url', value: url);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
