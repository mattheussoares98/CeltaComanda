import '../../../data/models/models.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

class RemoteLoadEnterpriseConcentradorParameters
    implements LoadEnterpriseConcentradorParameters {
  final HttpClient httpAdapter;

  RemoteLoadEnterpriseConcentradorParameters({required this.httpAdapter});

  @override
  Future<EnterpriseConcentradorParametersEntity> load({
    required int enterpriseId,
    required String concentradorUrl,
  }) async {
    try {
      var headers = {'Authorization': 'Basic MASTERPDV:PASSWORD'};

      final response = await httpAdapter.request(
        url:
            "$concentradorUrl/api/APIEnterpriseParameters/GetByEnterpriseId?enterpriseId=$enterpriseId",
        method: "get",
        headers: headers,
      );
      if (response == null) {
        throw Error();
      } else {
        return EnterpriseConcentradorParametersModel.fromJson(response)
            .toEntity();
      }
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
