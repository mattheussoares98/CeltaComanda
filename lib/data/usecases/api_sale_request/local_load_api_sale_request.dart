import '../../../data/models/models.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helperts.dart';
import '../../cache/cache.dart';

class LocalLoadApiSaleRequest
    implements LoadApiSaleRequest /* , ValidateLoginData */ {
  final HiveStorage hiveStorage;

  LocalLoadApiSaleRequest({required this.hiveStorage});

  @override
  Future<ApiSaleRequestEntity?> load(
    ApiSaleRequestEntity? apiSaleRequestEntity,
  ) async {
    try {
      final json = await hiveStorage.get(
        CacheKeys.apiSaleRequest.name,
      );
      if (json != null) {
        return _mapToEntity(json);
      } else {
        return null;
      }
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  ApiSaleRequestEntity? _mapToEntity(dynamic json) =>
      ApiSaleRequestModel.fromJson(json).toEntity();
}
