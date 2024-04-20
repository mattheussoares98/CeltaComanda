import '../../../data/models/models.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helperts.dart';
import '../../cache/cache.dart';

class LocalSaveApiSaleRequest implements SaveApiSaleRequest {
  final HiveStorage hiveStorage;

  LocalSaveApiSaleRequest({required this.hiveStorage});

  @override
  Future<void> save(ApiSaleRequestEntity entity) async {
    try {
      final json = _mapToJson(entity);
      await hiveStorage.put(
        CacheKeys.apiSaleRequest.name,
        json,
      );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  Map _mapToJson(ApiSaleRequestEntity entity) =>
      ApiSaleRequestModel.fromEntity(entity).toJson();
}
