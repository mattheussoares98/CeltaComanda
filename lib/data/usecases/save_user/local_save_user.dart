import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../cache/cache.dart';

class LocalSaveUser implements SaveUser {
  final CacheStorage cacheStorage;

  LocalSaveUser({required this.cacheStorage});

  @override
  Future<void> save(String user) async {
    try {
      await cacheStorage.save(key: 'user', value: user);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
