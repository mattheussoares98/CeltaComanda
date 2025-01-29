import '../../../infra/helpers/helpers.dart';

abstract class DeleteData {
  Future<void> delete(List<CacheKeys> keys);
}
