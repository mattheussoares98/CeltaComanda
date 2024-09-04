import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';

class RemoteFinishSaleRequestConcentrador
    implements FinishSaleRequestConcentrador {
  final HttpClient httpAdapter;

  RemoteFinishSaleRequestConcentrador({required this.httpAdapter});

  @override
  Future<void> finish({
    required int enterpriseId,
    required int pdvNumber,
    required int commandNumber,
  }) async {
    try {
      var headers = {'Authorization': 'Basic MASTERPDV:PASSWORD'};

      final response = await httpAdapter.request(
        url:
            "${EnterpriseDataBuilder.enterpriseDataEntity!.concentradorUrl!}/api/APISaleRequest/Finish?enterpriseId=${EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId}&pdvnumber=$pdvNumber&personalizedCode=$commandNumber",
        method: "put",
        headers: headers,
      );
      if (response == null) {
        throw Error();
      }
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
