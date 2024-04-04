import '../../../../domain/helpers/helpers.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../../../infra/helpers/helperts.dart';
import '../../../cache/cache.dart';

class LocalSaveUser implements SaveUserName {
  final CacheStorage cacheStorage;

  LocalSaveUser({required this.cacheStorage});

  @override
  Future<void> save(String userName) async {
    try {
      await cacheStorage.save(key: CacheKeys.userName.name, value: userName);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
