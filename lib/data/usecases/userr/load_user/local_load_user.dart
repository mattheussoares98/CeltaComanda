import '../../../../domain/helpers/helpers.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../../../infra/helpers/helperts.dart';
import '../../../cache/cache.dart';

class LocalLoadUser implements LoadUserName {
  final CacheStorage cacheStorage;

  LocalLoadUser({required this.cacheStorage});

  @override
  Future<String> load() async {
    try {
      final url = await cacheStorage.get(CacheKeys.userName.name);
      if (url == null) throw Error();
      return url;
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
