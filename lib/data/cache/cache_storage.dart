abstract class CacheStorage {
  Future<dynamic> get(String key);
  Future<void> delete(String key);
  Future<void> save({ required String key, required dynamic value });
}