import '../../../infra/helpers/helperts.dart';

abstract class DeleteData {
  Future<void> delete(List<CacheKeys> keys);
}
