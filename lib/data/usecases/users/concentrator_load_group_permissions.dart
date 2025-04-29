import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helpers.dart';
import '../../../main/builders/builders.dart';
import '../../database/database.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class ConcentratorLoadGroupPermissions implements LoadGroupPermissions {
  final HttpClient httpAdapter;
  final HiveStorage hiveStorage;
  ConcentratorLoadGroupPermissions({
    required this.httpAdapter,
    required this.hiveStorage,
  });

  @override
  Future<List<GroupPermissionConcentratorEntity>> getAll({
    required bool loadLocally,
  }) async {
    try {
      if (loadLocally) {
        final result = await hiveStorage.get(CacheKeys.groupPermissions.name);
        return (result as List)
            .map((e) => GroupPermissionConcentratorModel.fromJson(e).toEntity())
            .toList();
      }
      var headers = {'Authorization': 'Basic MASTERPDV:PASSWORD'};

      final url = EnterpriseBuilder.entity?.concentradorUrl;
      final response = await httpAdapter.request(
        url: '$url/api/APIGroupPermissions/GetAll',
        method: "get",
        headers: headers,
      );
      if (response == null) {
        throw Exception();
      } else {
        final result = (response as List)
            .map((e) => GroupPermissionConcentratorModel.fromJson(e).toEntity())
            .toList()
            .where(
              (e) => Permissions.values.any((p) =>
                  p.description.toLowerCase() ==
                  e.Permission?.Name?.toLowerCase()),
            )
            .toList();
        await hiveStorage.delete(CacheKeys.groupPermissions.name);
        await hiveStorage.put(
            CacheKeys.groupPermissions.name,
            result
                .map((e) =>
                    GroupPermissionConcentratorModel.fromEntity(e).toJson())
                .toList());
        return result;
      }
    } catch (e) {
      throw Exception();
    }
  }
}
