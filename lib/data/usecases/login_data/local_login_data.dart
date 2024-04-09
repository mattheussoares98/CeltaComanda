import 'package:clean_celta_mobile/data/models/login_data_model.dart';
import 'package:clean_celta_mobile/domain/entities/entities.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helperts.dart';
import '../../cache/cache.dart';

class LocalLoginData
    implements LoadLoginData, SaveLoginData /* , ValidateLoginData */ {
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
  Future<void> save(LoginDataEntity entity) async {
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

  // @override
  // Future<void> validate() async {
  //   try {
  //     final data = await hiveStorage.get(
  //       CacheKeys.loginData.name,
  //     );
  //     _mapToEntity(data);
  //   } catch (error) {
  //     await hiveStorage.delete(
  //       CacheKeys.loginData.name,
  //     );
  //   }
  // }

  LoginDataEntity? _mapToEntity(dynamic json) =>
      LoginDataModel.fromJson(json).toEntity();

  Map _mapToJson(LoginDataEntity entity) =>
      LoginDataModel.fromEntity(entity).toJson();
}
