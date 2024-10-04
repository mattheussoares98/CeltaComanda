import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteFinishSaleRequestConcentrador
    implements FinishSaleRequestConcentrador {
  final HttpClient httpAdapter;

  RemoteFinishSaleRequestConcentrador({required this.httpAdapter});

  @override
  Future<void> finish({
    required int pdvNumber,
    required int commandNumber,
    required List<ConcentratorFinalizationModel>? finalizations,
  }) async {
    try {
      var headers = {'Authorization': 'Basic MASTERPDV:PASSWORD'};

      String pdvNumberWithThreeNumbers = pdvNumber.toString().padLeft(3, "0");
      String commandNumberWithThreeNumbers =
          commandNumber.toString().padLeft(3, "0");

      String url =
          '${EnterpriseDataBuilder.enterpriseDataEntity!.concentradorUrl!}/api/APISaleRequest/Finish?enterpriseId=${EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId}&pdvnumber=$pdvNumberWithThreeNumbers&personalizedCode=$commandNumberWithThreeNumbers';
      if (finalizations != null) {
        url = "$url&finalizations=$finalizations";
      }
      final response = await httpAdapter.request(
        url: url,
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
