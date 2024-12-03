import 'package:clean_celta_mobile/domain/entities/pdv_entity.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';

class ConcentratorPdvRegistration implements PdvRegistration {
  final HttpClient httpAdapter;

  ConcentratorPdvRegistration({required this.httpAdapter});

  @override
  Future<void> getPdvNotUsing() async {
    try {
      var headers = {'Authorization': 'Basic MASTERPDV:PASSWORD'};

      final url = EnterpriseDataBuilder.enterpriseDataEntity!.concentradorUrl;
      final enterpriseId =
          EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId;

      final response = await httpAdapter.request(
        url: '$url/api/APIPdvs/GetPdvNotUsing?enterpriseId=$enterpriseId',
        method: "get",
        headers: headers,
      );
      if (response == null) {
        throw Error();
      } else {}
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  @override
  Future<List<PdvEntity>> setPdvRegister({
    required int pdvId,
    required String uniqueIdentifier,
    required String versionNumber,
  }) async {
    try {
      var headers = {'Authorization': 'Basic MASTERPDV:PASSWORD'};

      final url = EnterpriseDataBuilder.enterpriseDataEntity!.concentradorUrl;

      final response = await httpAdapter.request(
        url:
            '$url/api/APISaleRequest/APIPdvs/SetPdvRegister?pdvId=$pdvId&isUsing=true&ipAddress=127.0.0.1&macAddress=$uniqueIdentifier&versionNumber=$versionNumber',
        method: "post",
        headers: headers,
      );
      if (response == null) {
        throw Error();
      } else {}
      return [];
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
