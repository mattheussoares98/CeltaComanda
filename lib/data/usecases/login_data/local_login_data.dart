import '../../../data/models/models.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helperts.dart';
import '../../cache/cache.dart';

class LocalLoginData implements LoadLoginData, SaveLoginData {
  final HiveStorage hiveStorage;

  LocalLoginData({required this.hiveStorage});

  @override
  Future<LoginDataEntity?> load() async {
    try {
      final json = await hiveStorage.get(
        CacheKeys.loginData.name,
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
  Future<void> add(LoginDataEntity entity) async {
    try {
      final json = _mapToJson(entity);
      await hiveStorage.put(
        CacheKeys.loginData.name,
        json,
      );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  LoginDataEntity? _mapToEntity(dynamic json) =>
      LoginDataModel.fromJson(json).toEntity();

  Map _mapToJson(LoginDataEntity entity) =>
      LoginDataModel.fromEntity(entity).toJson();
}
