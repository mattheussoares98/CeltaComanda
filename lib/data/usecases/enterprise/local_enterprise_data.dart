import '../../mixins/mixins.dart';
import '../../models/models.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helpers.dart';
import '../../database/database.dart';

class LocalEnterpriseData
    with ErrorHandling
    implements LoadEnterpriseData, SaveEnterpriseData {
  final HiveStorage hiveStorage;

  LocalEnterpriseData({required this.hiveStorage});

  @override
  Future<EnterpriseEntity?> load() async {
    try {
      final json = await hiveStorage.get(
        CacheKeys.enterprise.name,
      );
      if (json != null) {
        return _mapToEntity(json);
      } else {
        return null;
      }
    } catch (e) {
      treatError(e);
    }
  }

  @override
  Future<void> add(EnterpriseEntity entity) async {
    try {
      final json = _mapToJson(entity);
      await hiveStorage.put(
        CacheKeys.enterprise.name,
        json,
      );
    } catch (e) {
      treatError(e);
    }
  }

  EnterpriseEntity? _mapToEntity(dynamic json) =>
      EnterpriseModel.fromJson(json).toEntity();

  Map _mapToJson(EnterpriseEntity entity) =>
      EnterpriseModel.fromEntity(entity).toJson();
}
