import 'package:clean_celta_mobile/data/models/enterprise_concentrador_parameters_model.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';

class RemoteLoadEnterpriseConcentradorParameters
    implements LoadEnterpriseConcentradorParameters {
  final HttpClient httpAdapter;

  RemoteLoadEnterpriseConcentradorParameters({required this.httpAdapter});

  @override
  Future<EnterpriseConcentradorParametersEntity> load(int enterpriseId) async {
    try {
      var headers = {'Authorization': 'Basic MASTERPDV:PASSWORD'};

      final response = await httpAdapter.request(
        url:
            "${EnterpriseDataBuilder.enterpriseDataEntity!.concentradorUrl!}/api/APIEnterpriseParameters/GetByEnterpriseId?enterpriseId=${EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId}",
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
