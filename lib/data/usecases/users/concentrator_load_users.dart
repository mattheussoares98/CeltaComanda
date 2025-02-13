import 'package:clean_celta_mobile/domain/entities/user_concentrator_entity.dart';

import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helpers.dart';
import '../../../main/builders/builders.dart';
import '../../database/database.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class ConcentratorLoadUsers implements LoadUsers {
  final HttpClient httpAdapter;
  final HiveStorage hiveAdapter;

  ConcentratorLoadUsers({
    required this.httpAdapter,
    required this.hiveAdapter,
  });

  @override
  Future<List<UserConcentratorEntity>> getAll({
    required bool loadLocally,
  }) async {
    try {
      if (loadLocally) {
        final result = await hiveAdapter.get(CacheKeys.users.name);
        return (result as List)
            .map((e) => UserConcentratorModel.fromJson(e).toEntity())
            .toList();
      }
      var headers = {'Authorization': 'Basic MASTERPDV:PASSWORD'};

      final url = EnterpriseBuilder.entity?.concentradorUrl;
      final enterpriseId = EnterpriseBuilder.entity?.enterpriseId;
      final response = await httpAdapter.request(
        url:
            '$url/api/APIUsers/GetAll?take=0&skip=0&search=&enterpriseId=$enterpriseId',
        method: "get",
        headers: headers,
      );
      if (response == null) {
        throw Exception();
      } else {
        final result = (response as List)
            .map((e) => UserConcentratorModel.fromJson(e).toEntity())
            .toList();

        await hiveAdapter.delete(CacheKeys.users.name);
        await hiveAdapter.put(
            CacheKeys.users.name,
            result
                .map((e) => UserConcentratorModel.fromEntity(e).toJson())
                .toList());

        return result;
      }
    } catch (e) {
      throw Exception();
    }
  }
}
