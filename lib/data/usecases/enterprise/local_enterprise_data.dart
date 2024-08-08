import '../../models/models.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helperts.dart';
import '../../database/database.dart';

class LocalEnterpriseData implements LoadEnterpriseData, SaveEnterpriseData {
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
    } catch (error) {
      throw DomainError.unexpected;
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
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  EnterpriseEntity? _mapToEntity(dynamic json) =>
      EnterpriseValidationModel.fromJson(json).toEntity();

  Map _mapToJson(EnterpriseEntity entity) =>
      EnterpriseValidationModel.fromEntity(entity).toJson();
}
