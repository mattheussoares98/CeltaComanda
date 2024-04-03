import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../cache/cache.dart';

class LocalSaveUrl implements SaveUrl {
  final CacheStorage cacheStorage;

  LocalSaveUrl({required this.cacheStorage});

  Future<void> get() async {
    try {
      final data = await cacheStorage.get('url');
      if (data?.isEmpty != false) {
        throw Exception();
      }
      return data;
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  @override
  Future<void> save(String url) async {
    try {
      await cacheStorage.save(key: 'url}', value: url);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
