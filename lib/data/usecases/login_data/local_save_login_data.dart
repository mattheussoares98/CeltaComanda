import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/save_login_data.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../infra/helpers/helperts.dart';

import '../../cache/cache.dart';

class LocalSaveUrl implements SaveLoginData {
  final CacheStorage cacheStorage;

  LocalSaveUrl({required this.cacheStorage});

  @override
  Future<void> save(LoginDataEntity loginData) async {
    try {
      await cacheStorage.save(key: CacheKeys.url.name, value: loginData);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
