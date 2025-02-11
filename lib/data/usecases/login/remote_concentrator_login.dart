import 'package:clean_celta_mobile/domain/entities/user_concentrator_entity.dart';

import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteConcentratorLogin implements ConcentratorLogin {
  final HttpClient httpAdapter;

  RemoteConcentratorLogin({required this.httpAdapter});

  @override
  Future<UserConcentratorEntity?> login({
    required String username,
    required String password,
  }) async {
    try {
      var headers = {'Authorization': 'Basic MASTERPDV:PASSWORD'};

      final concentradorUrl = EnterpriseBuilder.entity?.concentradorUrl;

      final response = await httpAdapter.request(
        url:
            "$concentradorUrl/api/APILogin/GetLogin?username=$username&password=$password",
        method: "get",
        headers: headers,
      );
      if (response == null) {
        throw Error();
      } else {
        return UserConcentratorModel.fromJson(response[0]).toEntity();
      }
    } catch (error) {
      return null;
    }
  }
}
