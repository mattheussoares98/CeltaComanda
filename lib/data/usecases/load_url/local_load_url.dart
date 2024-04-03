import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../cache/cache.dart';

class LocalLoadUrl implements LoadUrl {
  final CacheStorage cacheStorage;

  LocalLoadUrl({required this.cacheStorage});

  @override
  Future<String> load() async {
    try {
      final url = await cacheStorage.get('url');
      if (url == null) throw Error();
      return url;
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
